% THE script file tests the discrimination of feature extracted from CT and
% MR images. The overall training and testing process is in demo_2.m file.
% To save time, the feature generated in demo_2.m are saved in disk and
% loaded in the 


clc
close all
clear all

% You may change the currentFolder when evaluating. 
currentFolder = '/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment'; 
addpath(genpath(currentFolder))
% subject and coordinate can be randomly chosen for evaluation.
subject = 1;
coordinate = [28 62 31];  

% indexSubject does not seem to have a regular pattern. This is to follow the style of original dataset from hospital. 
indexSubjectTotal = [1:4, 6:8, 10, 12, 13];  

load([currentFolder '/Test/feature/p' num2str(subject) '/CTfeatureT_crop8060_p' num2str(subject) '.mat']);
load([currentFolder '/Test/feature/p' num2str(subject) '/MRIfeatureT_crop8060_p' num2str(subject) '.mat']);



 
KCCA_SimilarityMap(currentFolder, indexSubjectTotal(subject), coordinate, CTfeatureT,MRIfeatureT);
