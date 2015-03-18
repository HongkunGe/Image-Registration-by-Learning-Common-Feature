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