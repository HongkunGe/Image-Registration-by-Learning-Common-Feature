%% Training the alpha1 and alpha2. 


clc
clear all
close all

addpath(genpath('.'))
addpath(genpath('/home/liwa/matlab'))

weight_ROI = 0.95;
Mmax = 2000;
Num_samples = 2000;
patch_size = 5;
w = patch_size;

trainSubject = 14;
x1 = zeros(trainSubject * Num_samples, (2*patch_size+1).^3);
x2 = x1;

%% Sample in the Training subjects.
disp('Extracting Training Examples');
sampleIndex = 0;
for subjectID=[2 4 5 7 9 10 11 13 15 16 18 20 21 22]
    disp(['Process subject ' num2str(subjectID)]);
    
    dir_filename=['NORMAL0',num2str(subjectID),'/NORMAL0',num2str(subjectID),'-ls-corrected-later-flirt-demons'];
    info = analyze75info([dir_filename,'.hdr']);
    Img = analyze75read(info);
    seg = double(Img);
    
    dir_filename=['NORMAL0',num2str(subjectID),'/NORMAL0',num2str(subjectID),'_cbq-later-flirt-h-demons'];
    info = analyze75info([dir_filename,'.hdr']);
    Img = analyze75read(info);
    Img_T1 = double(Img);
    
    dir_filename=['NORMAL0',num2str(subjectID),'/NORMAL0',num2str(subjectID),'_cbq-denoise-warped-flirt-h-demons'];
    info = analyze75info([dir_filename,'.hdr']);
    Img = analyze75read(info);
    Img_T2 = double(Img);
% To get the ROI, but why?    
    phi = fm3d(double(Img_T2>5) - 0.5);
    phi2 = phi - 22;
    ROI = double(phi+1>0) - double(phi2>0);
    
    clear phi phi2
    
    index = find(ROI.*double(seg==250) == 1);
    
    a = datasample(1:size(index), int64(weigth_ROI*Num_samples), 'Replace', true);
    b = index(a);
    [ii, jj, zz] = ind2sub(size(ROI), b);
    
    sampleVisit = zeros(size(ROI));
    samplePerS = 0;
    for idx = 1:int64(weight_ROI*Num_samples)
        i = ii(idx); 
        j = jj(idx);
        z = zz(idx);
        sampleVisit(i,j,z) = 2;
        samplePerS = samplePerS + 1;
        sampleIndex = sampleIndex + 1;
        temp = Img_T1(i-w:i+w,j-w:j+w,z-w:z+w);
        x1(sampleIndex,:) = reshape(temp, [1, (2*w+1)^3]);
        temp = Img_T2(i-w:i+w,j-w:j+w,z-w:z+w);
        x2(sampleIndex,:) = reshape(temp, [1, (2*w+1)^3]);
    end
   
    temp = double(seg>0);
    index = find(temp == 1);
    
    a = datasample(1:size(index), int64((1 - weigth_ROI)*Num_samples), 'Replace', true);
    b = index(a);
    [ii, jj, zz] = ind2sub(size(ROI), b);
    
    for idx = 1:int64((1 - weigth_ROI)*Num_samples)
        i = ii(idx); 
        j = jj(idx);
        z = zz(idx);
        sampleVisit(i,j,z) = 1;
        samplePerS = samplePerS + 1;
        sampleIndex = sampleIndex + 1;
        temp = Img_T1(i-w:i+w,j-w:j+w,z-w:z+w);
        x1(sampleIndex,:) = reshape(temp, [1, (2*w+1)^3]);
        temp = Img_T2(i-w:i+w,j-w:j+w,z-w:z+w);
        x2(sampleIndex,:) = reshape(temp, [1, (2*w+1)^3]);
    end
    
    toc 
end


