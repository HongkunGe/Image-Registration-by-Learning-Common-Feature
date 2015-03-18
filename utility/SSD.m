function [ diffD ]=SSD(NP,T)

temp = ones(size(NP,1),1) * T / norm(T);
NPnorm = sum(NP .^2, 2) * ones(1,size(NP,2));
NP = NP ./ NPnorm;
diff = sum((NP - temp) .^2 , 2);% ./N ./(norm(T)^2);
diffD =  ones(size(diff)) - sqrt(diff); % /max(diff(:))

end