% dir_input = '/Users/hkge1991/Documents/MATLAB/Research_6/5-fold_experiment/utility/keyPoints/';
% prst = imread([dir_input 'keyPoint.jpg']);
% imshow(prst);
% BW = edge(prst(:,:,1),'canny');
% imshow(BW);


% s = rand(10000,2).*.5;
% s = [s,bsxfun(@hypot,s(:,1),s(:,2))];
% in = s(s(:,3)<.5,1:2);
% out = s(s(:,3)>=.5,1:2);
% plot(in(:,1),in(:,2),'g.')
% hold
% plot(out(:,1),out(:,2),'r.')
% axis square


s= rand(10000, 1);
s2= rand(10000, 1);
plot(s(:), s2(:), 'r.');

 n1=3; n2=4; A=normrnd(0,0.02,n1,n2); mean(A(:)) 
 n1=300; n2=400; A=normrnd(0,0.02,n1,n2); mean(A(:)) 
 n1=3000; n2=40000; A=normrnd(0,0.02,n1,n2); mean(A(:))