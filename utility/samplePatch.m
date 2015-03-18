function [x1, x2] = samplePatch(dir_input,  patchSize1,patchSize2,patchSize3, NumSamplesPerSubject, indexSubject)
%  samplePatch gets the training sample patches from CT and MRI for 5-fold experiment. 
%  INPUT: dir_input             -directory of training and testing set. 
%         patchSize1,2,3        -size of patch. 7*7*5 in our experiment. 
%         NumSamplePerSubject   -number of sample per subject.
%         indexSubjectToatal    -Total indexes of the subject. To get
%                                training set, we extract the supplementary  
%                                set of testSet.
%         testSet               -index of test subject. 
%  OUTPUT:x1,x2                 -Training set with size N*p. N is sample
%                                number, p is dimension.

for count=1:length(indexSubject)
infoCT = analyze75info([dir_input '/Prostate_MRI_CT/p' num2str(indexSubject(count)) '/CT_p'  num2str(indexSubject(count)) '.hdr']);
dataCT = double(analyze75read(infoCT));
infoMRI = analyze75info([dir_input '/Prostate_MRI_CT/p' num2str(indexSubject(count)) '/MRI_p'  num2str(indexSubject(count)) '.hdr']);
dataMRI = double(analyze75read(infoMRI));

[r,c,v]=size(dataCT);
nump1 = NumSamplesPerSubject * 1;
randIndex_r=randi([33, 112],nump1,1);  % After discussed with Miss.Yanrong, 90% patches are at the location of prostate.
randIndex_c=randi([56, 135],nump1,1);
randIndex_v=randi([2 , 41 ],nump1,1);  % XYZ  80x80x30

% nump2 = numPoint - nump1;
% randIndex_r=[randIndex_r; randi(r,nump2,1)];
% randIndex_c=[randIndex_c; randi(c,nump2,1)];
% randIndex_v=[randIndex_v; randi(v,nump2,1)];

scatter3(randIndex_r,randIndex_c,randIndex_v);

patchSubjectCT  = zeros(NumSamplesPerSubject,patchSize1*patchSize2*patchSize3);
patchSubjectMRI = zeros(NumSamplesPerSubject,patchSize1*patchSize2*patchSize3);
for i = 1:NumSamplesPerSubject
    indexr=randIndex_r(i);indexc=randIndex_c(i);indexv=randIndex_v(i);
    if r-randIndex_r(i)<patchSize1-1
       indexr=randIndex_r(i)-patchSize1;
    end
    if c-randIndex_c(i)<patchSize2-1
       indexc=randIndex_c(i)-patchSize2;
    end
    if v-randIndex_v(i)<patchSize3-1
       indexv=randIndex_v(i)-patchSize3;
    end
    patchTempCT  = dataCT (indexr:indexr+patchSize1-1,indexc:indexc+patchSize2-1,indexv:indexv+patchSize3-1);
    patchTempMRI = dataMRI(indexr:indexr+patchSize1-1,indexc:indexc+patchSize2-1,indexv:indexv+patchSize3-1);
    % imshow(patchTemp(:,:,1));
    patchSubjectCT(i,:)  = double(patchTempCT(:))/65535;
    patchSubjectMRI(i,:) = double(patchTempMRI(:))/65535;
    
end

patchSubjectTotalCT((count-1)*NumSamplesPerSubject+1:count*NumSamplesPerSubject,:)  = patchSubjectCT;  
patchSubjectTotalMRI((count-1)*NumSamplesPerSubject+1:count*NumSamplesPerSubject,:) = patchSubjectMRI;  
end

x1 = patchSubjectTotalCT;
x2 = patchSubjectTotalMRI;
end

