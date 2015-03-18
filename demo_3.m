clc
close all
clear all

currentFolder = '/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment'; 
addpath(genpath(currentFolder))
% indexSubject does not seem to have a regular pattern. This is to follow the style of original dataset from hospital. 
indexSubjectTotal = [1:4, 6:8, 10, 12, 13];  
%% 1 fold
subject1 = 1;
subject2 = 2;
LOADALPHA = 0;
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