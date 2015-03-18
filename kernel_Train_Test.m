function [ CTfeatureT, MRIfeatureT ] = fold_Num(x1,x2, x_test, y_test )
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
% Hongkun GE. All Right Reserved.

%---------------------------------------
Mmax = 8000;         %rank of ICD matrix G: K=GG'; The more the better but more time-consumption
kernelSigma = 1;   %  sigma of Guassian kernel  
kappa = 0.5;         %  regularization term [0 1]
K_largerest = 0.6;   %  only select the coeeficients larger than 0.6 [0 1]
kernel1 = {'gauss',kernelSigma};   % kernel type and kernel parameter for data set 1
kernel2 = {'gauss',kernelSigma};   % kernel type and kernel parameter for data set 2
%--------------------------------------- 

TotalNumTrainSamples = size(x1,1);
x1_mean = mean(x1);
x2_mean = mean(x2);

% Move the center of every sample to the origin.
x1 = x1-repmat(mean(x1),TotalNumTrainSamples,1);
x2 = x2-repmat(mean(x2),TotalNumTrainSamples,1);

%% KERNEL CCA training.
disp('KCCA training...')
tic
[r,alpha1,alpha2] = km_kcca_li2(x1,x2,kernel1,kernel2,kappa,'ICD',Mmax,K_largerest);
toc
%  The first subject index is used to indicate the index of the alpha
%  parameter set. 

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

    xTotal = x_test;       %--------------------------------------- TEST Data here
    [TotalNumTestSamples,~] = size(xTotal);
    xTotal = xTotal-repmat(x1_mean,TotalNumTestSamples,1);  
    K1 = km_kernel(xTotal,x1,kernel1{1},kernel1{2}) - repmat(K1_row_mean,[TotalNumTestSamples 1]);
    ctFeature = K1*alpha1;
    
    yTotal = y_test;      %--------------------------------------- TEST Data here
    [TotalNumTestSamples,~] = size(yTotal);
    yTotal = yTotal-repmat(x2_mean,TotalNumTestSamples,1);  
    K2 = km_kernel(yTotal,x2,kernel2{1},kernel2{2}) - repmat(K2_row_mean,[TotalNumTestSamples 1]);
    mriFeature = K2*alpha2;
    
    CTfeatureT( (imageNo-1)*6400+1:imageNo*6400, :)  = ctFeature;  
    MRIfeatureT((imageNo-1)*6400+1:imageNo*6400, :)  = mriFeature;

