function [ corr ]=NCC(NP,T)
for i = 1:size(NP,1)
    corr(i) = dot(NP(i,:),T)/norm(NP(i,:))/norm(T);
end
end

