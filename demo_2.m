%% 5_Fold experiment on 10 subjects.
%  This script file implements the the overall training and testing process
%  of Kernel CCA. 
%  8 pairs of images are used for training while the rest 2 images are used
%  for testing. The Features calculated are stored in corresponding
%  folders. The returned feature are only used for evaluation. 
%  ATTENTIONS!! The training time for each fold will cost about 3 hours. 
clc
close all
clear all

currentFolder = '/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment'; 
addpath(genpath(currentFolder))
% indexSubject does not seem to have a regular pattern. This is to follow the style of original dataset from hospital. 
indexSubjectTotal = [1:4, 6:8, 10, 12, 13];  
%% 1 fold
% subject1 = 1;
% subject2 = 2;
% [CTfeatureT, MRIfeatureT] = fold_Num(currentFolder, subject1, subject2, 0);
% 
% % To evaluate the feature trained by kernel CCA, Draw the similarity map by
% % color code. coordinate can be randomly chosen for evaluation.
% coordinate = [37 29 21];  
% KCCA_SimilarityMap(currentFolder, indexSubjectTotal(subject2), coordinate, CTfeatureT,MRIfeatureT);

%% 2 fold
subject1 = 3;
subject2 = 4;
[CTfeatureT, MRIfeatureT] = fold_Num(currentFolder, subject1, subject2, 0);
coordinate = [37 29 21];  
KCCA_SimilarityMap(currentFolder, indexSubjectTotal(subject2), coordinate, CTfeatureT,MRIfeatureT);

%% 3 fold
subject1 = 5;
subject2 = 6;
[CTfeatureT, MRIfeatureT] = fold_Num(currentFolder, subject1, subject2, 0);
coordinate = [37 29 21];  
KCCA_SimilarityMap(currentFolder, indexSubjectTotal(subject2), coordinate, CTfeatureT,MRIfeatureT);

%% 4 fold
subject1 = 7;
subject2 = 8;
[CTfeatureT, MRIfeatureT] = fold_Num(currentFolder, subject1, subject2, 0);
coordinate = [37 29 21];  
KCCA_SimilarityMap(currentFolder, indexSubjectTotal(subject2), coordinate, CTfeatureT,MRIfeatureT);

%% 5 fold
subject1 = 9;
subject2 = 10;
[CTfeatureT, MRIfeatureT] = fold_Num(currentFolder, subject1, subject2, 0);
coordinate = [37 29 21];  
KCCA_SimilarityMap(currentFolder, indexSubjectTotal(subject2), coordinate, CTfeatureT,MRIfeatureT);
