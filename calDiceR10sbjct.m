Dicepro = zeros(10,4);
for i=[1 2 3 4 6 7 8 10]
    info = analyze75info(['/Users/hkge1991/SharedFile/ShareData5fold/warp_mr_pro/xmr_pro_crop8060_output_p' num2str(i) '.hdr']);%p' num2str(index) '/MRI_p' num2str(index)  '.hdr']);
    dataCT = double(analyze75read(info));           
    info = analyze75info(['/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment/Test/feature/p' num2str(i) '/ct_pro_crop8060_p'  num2str(i) '.hdr']);%  pro_output_p12    p' num2str(index) '/CT_p'  num2str(index) '.hdr']);
    dataMRI = double(analyze75read(info));
    Dicepro(i,1) = calDiceRatio( dataCT, dataMRI );
end

for i=[1 2 3 4 6 7 8 10]
    info = analyze75info(['/Users/hkge1991/SharedFile/ShareData5fold/warp_mr_pro_v2/xmr_pro_crop8060_output_v2_p' num2str(i) '.hdr']);%p' num2str(index) '/MRI_p' num2str(index)  '.hdr']);
    dataCT = double(analyze75read(info));           
    info = analyze75info(['/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment/Test/feature/p' num2str(i) '/ct_pro_crop8060_p'  num2str(i) '.hdr']);%  pro_output_p12    p' num2str(index) '/CT_p'  num2str(index) '.hdr']);
    dataMRI = double(analyze75read(info));
    Dicepro(i,2) = max(Dicepro(i,1), calDiceRatio( dataCT, dataMRI ));
end

for i=[1 2 3 4 6 7 8 10]
    info = analyze75info(['/Users/hkge1991/SharedFile/ShareData5fold/warp_mr_pro_Elastix_v2/xmr_pro_crop8060_elastix_output_p' num2str(i) '.hdr']);%p' num2str(index) '/MRI_p' num2str(index)  '.hdr']);
    dataCT = double(analyze75read(info));           
    info = analyze75info(['/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment/Test/feature/p' num2str(i) '/ct_pro_crop8060_p'  num2str(i) '.hdr']);%  pro_output_p12    p' num2str(index) '/CT_p'  num2str(index) '.hdr']);
    dataMRI = double(analyze75read(info));
    Dicepro(i,3) = calDiceRatio( dataCT, dataMRI );
end

for i=[1 2 3 4 6 7 8 10]
    info = analyze75info(['/Users/hkge1991/SharedFile/ShareData5fold/warp_mr_pro_Elastix/xmr_pro_crop8060_elastix_output_p' num2str(i) '.hdr']);%p' num2str(index) '/MRI_p' num2str(index)  '.hdr']);
    dataCT = double(analyze75read(info));           
    info = analyze75info(['/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment/Test/feature/p' num2str(i) '/ct_pro_crop8060_p'  num2str(i) '.hdr']);%  pro_output_p12    p' num2str(index) '/CT_p'  num2str(index) '.hdr']);
    dataMRI = double(analyze75read(info));
    Dicepro(i,4) = max(Dicepro(i,3), calDiceRatio( dataCT, dataMRI ));
end

for i=[1 2 3 4 6 7 8 10]
    info = analyze75info(['/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment/Test/feature/p' num2str(i) '/mr_pro_crop8060_p'  num2str(i) '.hdr']);%p' num2str(index) '/MRI_p' num2str(index)  '.hdr']);
    dataCT = double(analyze75read(info));           
    info = analyze75info(['/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment/Test/feature/p' num2str(i) '/ct_pro_crop8060_p'  num2str(i) '.hdr']);%  pro_output_p12    p' num2str(index) '/CT_p'  num2str(index) '.hdr']);
    dataMRI = double(analyze75read(info));
    Dicepro(i,5) = calDiceRatio( dataCT, dataMRI );
end
subject1112 = [0.887300000000000,0.829700000000000;0.858000000000000,0.751400000000000];
id=[1 2 3 4 7 8 10 11 12]
result1 = Dicepro(:,[2,4]);

result1 = [result1;subject1112];
result1 = result1(id,:);
meanR = mean(result1)
stdR = std(result1)

figure(11)
bar(result1);
xlabel('Subject No.');
ylabel('Dice Ratio');
legend('Proposed method', 'MI-based method');
title('Dice Ratio');