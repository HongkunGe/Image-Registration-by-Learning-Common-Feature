function [ Dice2 ] = calDiceRatio( dataCT, dataMRI )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    dataCT = dataCT(:,:,15:45);
    dataCT(dataCT<100) = 0;
    dataCT(dataCT>=100) = 1;
    
    dataMRI =dataMRI(:,:,15:45);
    dataMRI(dataMRI<100) = 0;
    dataMRI(dataMRI>=100) = 1;
    
    intersection = dataCT.*dataMRI;
    union = dataCT+dataMRI;
    union(union>1) = 1;
%     Dice = sum(intersection(:))/sum(union(:))
%     Overlap = sum(intersection(:))/sum(dataCT(:))
    union2 = dataCT+dataMRI;
    Dice2 = 2*sum(intersection(:))/sum(union2(:));
end

