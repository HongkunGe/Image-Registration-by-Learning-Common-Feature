function PatchSubject = getWholePatchCT_kcca(data, patchSize1, patchSize2, patchSize3, plane)
data = data(33-floor(patchSize1/2) : 112+floor(patchSize1/2), ...
            56-floor(patchSize1/2) : 135+floor(patchSize1/2), :);% rcv YXZ

[r,c,v]=size(data);
    index = 1;
    x = floor(patchSize1/2);
    y = floor(patchSize2/2);
    z = floor(patchSize3/2);

    PatchSubject = zeros((c-floor(patchSize1/2)*2)*(r-floor(patchSize1/2)*2), patchSize1*patchSize2*patchSize3); % (v-2*z)*
    for k = plane
        for j = 1+floor(patchSize1/2):c-floor(patchSize1/2)
            for i = 1+floor(patchSize1/2):r-floor(patchSize1/2)
                Temp = data(i-x:i+x,j-y:j+y,k-z:k+z);
                PatchSubject(index,:) = Temp(:);
                index = index+1;
            end
        end
    end
end