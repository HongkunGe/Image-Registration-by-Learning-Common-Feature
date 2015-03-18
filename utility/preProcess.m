function [ dataTestCT, dataTestMRI ] = preProcess( dir_input, index )
% preProcess function aims to pre-process the images inputed.
% Preprocess includes truncation, normalization and histogram matching. 
% INPUT:  dir_input      -directory for input images.
%         index          -index of subjects in the work space. 
% OUTPUT: dataTestCT, dataTestMRI
%                        -PREPROCESSED CT and MR images data.
%% Read
% ctmr{1}=double(analyze75read('/Users/hkge1991/Shared File/SHAREresearchData/for_hongkun/p12/ct_CS_p12.hdr'));
% mrct{1}=double(analyze75read('/Users/hkge1991/Shared File/SHAREresearchData/for_hongkun/p12/mri_CS_p12.hdr'));

ctmr{1}=double(analyze75read([dir_input '/p' num2str(index) '/ct_CS_p' num2str(index) '.hdr']));
mrct{1}=double(analyze75read([dir_input '/p' num2str(index) '/mri_CS_p' num2str(index) '.hdr']));

[r,c,v]=size(ctmr{1});

%% Truncate the pixel which is too large.
cutThrsd=2500;
ctmr{1}(ctmr{1}>cutThrsd) = cutThrsd;
%% Normalization

max_ctmr=2500;
min_ctmr=0; 
max_mrct=949;
min_mrct=-48;    

t1=max(ctmr{1}(:));
t2=min(ctmr{1}(:));
m1=max(mrct{1}(:));
m2=min(mrct{1}(:));
for i=1
    ctmr{i}=(ctmr{i}-min_ctmr)/(max_ctmr-min_ctmr);
    mrct{i}=(mrct{i}-min_mrct)/(max_mrct-min_mrct);
end

%% Histogram Matching 
for i=1
     ct{i}=imhistmatch(ctmr{i},mrct{i});
     mr{i}=mrct{i};
end
sub=ct{i};  dataTestCT = int16(sub*65535);   % save('dataCT_p12.mat','dataTestCT');  
sub=mr{i};  dataTestMRI = int16(sub*65535);  % save('dataMRI_p12.mat','dataTestMRI');
end
