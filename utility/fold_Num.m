function [ CTfeatureT, MRIfeatureT ] = fold_Num(currentFolder, subject1, subject2, LOADALPHA)
%fold_Num: aims to generate the feature of subject1 and subject2 in the
%total set of 10 subjects. The modal used is kernel CCA. 
%subject1 and subject2 serve as the testing sets while the rest as the training sets. 
% INPUT:  currentFolder             -FOLDER for work space.
%         subject1,subject2         -The first and second indexes of testing
%                                    images, The rest 8 subjects in the work space
%                                    serve as the training images.
% OUTPUT: CTfeatureT, MRIfeatureT   -The feature of CT and MR images of
%                                    subject2. All the feature calculated
%                                    are saved to the disk. The feature
%                                    outputed here is used for evaluation.
% Hongkun GE. All Right Reserved.(currentFolder, subject1, subject2, LOADALPHA)

% indexSubject does not seem to have a regular pattern. This is to follow the style of original dataset from hospital. 
indexSubjectTotal = [1:4, 6:8, 10, 12, 13];  
%% 1 fold
%---------------------------------------
Mmax = 8000;         %rank of ICD matrix G: K=GG'; The more the better but more time-consumption
kernelSigma = 1;   %  sigma of Guassian kernel  
kappa = 0.5;         %  regularization term [0 1]
K_largerest = 0.6;   %  only select the coeeficients larger than 0.6 [0 1]
kernel1 = {'gauss',kernelSigma};   % kernel type and kernel parameter for data set 1
kernel2 = {'gauss',kernelSigma};   % kernel type and kernel parameter for data set 2
%--------------------------------------- 
NumSamplesPerSubject = 2000;  % how many training samples extracted from each training subject
patchSize1 = 7; patchSize2 = 7; patchSize3 = 5;
%--------------------------------------- 

%% Training set. Get training sample from the supplementary set of [subject1, subject2]. 
disp(['Testing Subjects ' num2str(indexSubjectTotal(subject1)) ' and ' num2str(indexSubjectTotal(subject2))]);
disp('Extracting samples...')
% currentFolder = '/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment'; 
indexSubject = setdiff(indexSubjectTotal, [indexSubjectTotal(subject1), indexSubjectTotal(subject2)]);
if LOADALPHA == 0
    disp('No Loading x1 and x2, But randomly choose sample patches');
tic
[x1, x2] = samplePatch(currentFolder,  patchSize1,patchSize2,patchSize3,  NumSamplesPerSubject,  indexSubject);
toc
else
    load([currentFolder '/Test/alpha/x1_p' num2str(indexSubjectTotal(subject1))]);
    load([currentFolder '/Test/alpha/x2_p' num2str(indexSubjectTotal(subject1))]);
end
TotalNumTrainSamples = size(x1,1);
x1_mean = mean(x1);
x2_mean = mean(x2);

% Move the center of every sample to the origin.
x1 = x1-repmat(mean(x1),TotalNumTrainSamples,1);
x2 = x2-repmat(mean(x2),TotalNumTrainSamples,1);

%% KERNEL CCA training.
disp('KCCA training...')
if LOADALPHA == 0
    disp('No Loading ALPHA, But Training Alpha');
tic
[r,alpha1,alpha2] = km_kcca_HK(x1,x2,kernel1,kernel2,kappa,'ICD',Mmax,K_largerest);
toc

%  The first subject index is used to indicate the index of the alpha
%  parameter set. 

save([currentFolder '/Test/alpha/alpha1_p' num2str(indexSubjectTotal(subject1))],'alpha1');
save([currentFolder '/Test/alpha/alpha2_p' num2str(indexSubjectTotal(subject1))],'alpha2');
save([currentFolder '/Test/alpha/x1_p' num2str(indexSubjectTotal(subject1))],'x1');
save([currentFolder '/Test/alpha/x2_p' num2str(indexSubjectTotal(subject1))],'x2');
% save alpha alpha1 alpha2
save('r.mat','r');
else 
    disp('No Training Alpha, But Loading ALPHA');
    load([currentFolder '/Test/alpha/alpha1_p' num2str(indexSubjectTotal(subject1))]);
    load([currentFolder '/Test/alpha/alpha2_p' num2str(indexSubjectTotal(subject1))]);
end

% Compute the mean of every coloum for training kernel matrix, we get the a row of mean. 
tic
K1_row_mean=zeros(1000,TotalNumTrainSamples);
K2_row_mean=zeros(1000,TotalNumTrainSamples);

for ii=1:1000:TotalNumTrainSamples
    K1_row_mean = K1_row_mean + (km_kernel(x1(ii:ii+1000-1,:),x1,kernel1{1},kernel1{2}));
    K2_row_mean = K2_row_mean + (km_kernel(x2(ii:ii+1000-1,:),x2,kernel2{1},kernel2{2}));
end
K1_row_mean = mean(K1_row_mean)./(TotalNumTrainSamples/1000);
K2_row_mean = mean(K2_row_mean)./(TotalNumTrainSamples/1000);
toc

%% Testing set: subject1.
dirTest = [currentFolder '/Test/feature/'];
dirTestMR = [currentFolder '/Test/ElastixLinear/'];
[dataTestCT, dataTestMRI] = preProcess_V2(dirTest, dirTestMR, indexSubjectTotal(subject1));
dataTestCT  = double(dataTestCT )/65535;
dataTestMRI = double(dataTestMRI)/65535;
for imageNo = 1:60
    disp(['processing imageNo.' num2str(imageNo)]);
    tic    
    CTPatchSubject  = getWholePatchCT_kcca( dataTestCT,  patchSize1, patchSize2, patchSize3, imageNo+2);
    MRIPatchSubject = getWholePatchMRI_kcca(dataTestMRI, patchSize1, patchSize2, patchSize3, imageNo+2);    
    
    xTotal = CTPatchSubject;
    [TotalNumTestSamples,~] = size(xTotal);
    xTotal = xTotal-repmat(x1_mean,TotalNumTestSamples,1);  
    K1 = km_kernel(xTotal,x1,kernel1{1},kernel1{2}) - repmat(K1_row_mean,[TotalNumTestSamples 1]);
    ctFeature = K1*alpha1;
    
    yTotal = MRIPatchSubject;
    [TotalNumTestSamples,~] = size(yTotal);
    yTotal = yTotal-repmat(x2_mean,TotalNumTestSamples,1);  
    K2 = km_kernel(yTotal,x2,kernel2{1},kernel2{2}) - repmat(K2_row_mean,[TotalNumTestSamples 1]);
    mriFeature = K2*alpha2;
    
    CTfeatureT( (imageNo-1)*6400+1:imageNo*6400, :)  = ctFeature;  
    MRIfeatureT((imageNo-1)*6400+1:imageNo*6400, :)  = mriFeature;
    toc
end
% mkdir([currentFolder '/Test/feature/p' num2str(indexSubjectTotal(subject1))]);
%??????????????????????????????????????????????????????????????????????????????????????????????????????
% coordinate = [37 29 21];  
% KCCA_SimilarityMap(currentFolder, indexSubjectTotal(subject1), coordinate, CTfeatureT,MRIfeatureT);
%??????????????????????????????????????????????????????????????????????????????????????????????????????
save([dirTest 'p' num2str(indexSubjectTotal(subject1)) '/CTfeatureT_crop8060_p'  num2str(indexSubjectTotal(subject1)) '.mat'], 'CTfeatureT');
save([dirTest 'p' num2str(indexSubjectTotal(subject1)) '/MRIfeatureT_crop8060_p' num2str(indexSubjectTotal(subject1)) '.mat'], 'MRIfeatureT');

  fileID  = fopen([dirTest 'p' num2str(indexSubjectTotal(subject1)) '/prostate_CT_256000_KCCA_crop8060_p' num2str(indexSubjectTotal(subject1)) '.bin'],'w');
  fwrite(fileID,  CTfeatureT, 'float');
  fclose(fileID);
  
  fileID2 = fopen([dirTest 'p' num2str(indexSubjectTotal(subject1)) '/prostate_MRI_256000_KCCA_crop8060_p' num2str(indexSubjectTotal(subject1)) '.bin'],'w');   
  fwrite(fileID2, MRIfeatureT,'float');
  fclose(fileID2);
  
%% Testing set: subject2.
dirTest = [currentFolder '/Test/feature/'];
dirTestMR = [currentFolder '/Test/ElastixLinear/'];
[dataTestCT, dataTestMRI] = preProcess_V2(dirTest, dirTestMR, indexSubjectTotal(subject1));
dataTestCT  = double(dataTestCT) /65535;
dataTestMRI = double(dataTestMRI)/65535;
for imageNo = 1:60
    disp(['processing imageNo.' num2str(imageNo)]);
    tic    
    CTPatchSubject  = getWholePatchCT_kcca( dataTestCT,  patchSize1, patchSize2, patchSize3, imageNo+2);
    MRIPatchSubject = getWholePatchMRI_kcca(dataTestMRI, patchSize1, patchSize2, patchSize3, imageNo+2);    
    
    xTotal = CTPatchSubject;
    [TotalNumTestSamples,~] = size(xTotal);
    xTotal = xTotal-repmat(x1_mean,TotalNumTestSamples,1);  
    K1 = km_kernel(xTotal,x1,kernel1{1},kernel1{2}) - repmat(K1_row_mean,[TotalNumTestSamples 1]);
    ctFeature = K1*alpha1;
    
    yTotal = MRIPatchSubject;
    [TotalNumTestSamples,~] = size(yTotal);
    yTotal = yTotal-repmat(x2_mean,TotalNumTestSamples,1);  
    K2 = km_kernel(yTotal,x2,kernel2{1},kernel2{2}) - repmat(K2_row_mean,[TotalNumTestSamples 1]);
    mriFeature = K2*alpha2;
    
    CTfeatureT( (imageNo-1)*6400+1:imageNo*6400, :)  = ctFeature;  
    MRIfeatureT((imageNo-1)*6400+1:imageNo*6400, :)  = mriFeature;
    toc
end
% mkdir([currentFolder '/Test/feature/p' num2str(indexSubjectTotal(subject2))]);

save([dirTest 'p' num2str(indexSubjectTotal(subject2)) '/CTfeatureT_crop8060_p'  num2str(indexSubjectTotal(subject2)) '.mat'], 'CTfeatureT');
save([dirTest 'p' num2str(indexSubjectTotal(subject2)) '/MRIfeatureT_crop8060_p' num2str(indexSubjectTotal(subject2)) '.mat'], 'MRIfeatureT');

  fileID  = fopen([dirTest 'p' num2str(indexSubjectTotal(subject2)) '/prostate_CT_256000_KCCA_crop8060_p' num2str(indexSubjectTotal(subject2)) '.bin'],'w');
  fwrite(fileID,  CTfeatureT, 'float');
  fclose(fileID);
  
  fileID2 = fopen([dirTest 'p' num2str(indexSubjectTotal(subject2)) '/prostate_MRI_256000_KCCA_crop8060_p' num2str(indexSubjectTotal(subject2)) '.bin'],'w');   
  fwrite(fileID2, MRIfeatureT,'float');
  fclose(fileID2);