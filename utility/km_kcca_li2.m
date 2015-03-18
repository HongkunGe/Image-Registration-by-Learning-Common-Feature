function [r,alpha1,alpha2] = km_kcca_HK(X1,X2,kernel1,kernel2,reg,decomp,lrank,K_largerest)
% KM_KCCA performs kernel canonical correlation analysis.
% Input:	- X1, X2: data matrices containing one datum per row
%			- kernel1, kernel2: structures containing kernel type (e.g. 
%			'gauss') and kernel paraemters for each data set
%			- kernelpar: kernel parameter value
%			- reg: regularization
%			- decomp: low-rank decomposition technique (e.g. 'ICD')
%			- lrank: target rank of decomposed matrices
% Output:	- y1, y2: nonlinear projections of X1 and X2 (estimates of the
%			latent variable)
%			- beta: first canonical correlation
% USAGE: [y1,y2,beta] = km_kcca(X1,X2,kernel1,kernel2,reg,decomp,lrank)
%
% Author: Steven Van Vaerenbergh (steven *at* gtas.dicom.unican.es), 2012.
% Id: km_kcca.m v1.1 2012/04/08
% This file is part of the Kernel Methods Toolbox (KMBOX) for MATLAB.
% http://sourceforge.net/p/kmbox
%
% The algorithm in this file is based on the following publications:
% D. R. Hardoon, S. Szedmak and J. Shawe-Taylor, "Canonical Correlation
% Analysis: An Overview with Application to Learning Methods", Neural
% Computation, Volume 16 (12), Pages 2639--2664, 2004.
% F. R. Bach, M. I. Jordan, "Kernel Independent Component Analysis", Journal
% of Machine Learning Research, 3, 1-48, 2002.
%
% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation, version 3 (http://www.gnu.org/licenses).
%
%
% MODIFIED by Hongkun Ge. V1
N = size(X1,1);	% number of data

if nargin<6
	decomp = 'full';
end

switch decomp
	case 'ICD' % incomplete Cholesky decomposition

		% get incompletely decomposed kernel matrices. K1 \approx G1*G1'
		G1 = km_kernel_icd(X1,kernel1{1},kernel1{2},lrank);
		G2 = km_kernel_icd(X2,kernel2{1},kernel2{2},lrank);

        G1_d=size(G1,2);
        
		% remove mean. avoid standard calculation N0 = eye(N)-1/N*ones(N);
		G1 = G1-repmat(mean(G1),N,1);
		G2 = G2-repmat(mean(G2),N,1);

		% ones and zeros
		N1 = size(G1,2); N2 = size(G2,2);
		Z11 = zeros(N1); Z22 = zeros(N2); Z12 = zeros(N1,N2);
		I11 = eye(N1); I22 = eye(N2);

		% 3 GEV options, all of them are fairly equivalent

		% % option 1: standard Hardoon
% 		R = [Z11 G1'*G1*G2'*G2; G2'*G2*G1'*G1 Z22];
% 		D = [G1'*G1*G1'*G1+reg*I11 Z12; Z12' G2'*G2*G2'*G2+reg*I22];
% 		R = [Z11 G1'*G1*G1'*G2; G2'*G2*G2'*G1 Z22];
% 		D = [G1'*G1*G1'*G1+reg*I11 Z12; Z12' G2'*G2*G2'*G2+reg*I22];
		% option 2: simplified Hardoon
% 		R = [Z11 G1'*G2; G2'*G1 Z22];
% 		D = [G1'*G1+reg*I11 Z12; Z12' G2'*G2+reg*I22];
		% option 3: Kettenring-like generalizable formulation
		R = 1/2*[G1'*G1 G1'*G2; G2'*G1 G2'*G2];
		D = [G1'*G1+reg*I11 Z12; Z12' G2'*G2+reg*I22];

        
        [alphas,betas] = eig(R,D);
        [r, i] = sort(real(diag(betas)),'descend');
        
        ii=double(r>0.8);
        
        alphas=alphas(:,i);
        betas = betas(:,i);

        temp=double(r>K_largerest);
        alphas = alphas(:,1:sum(temp(:)));
        betas =	betas(:,1:sum(temp(:)));
       
        alpha=alphas;
		alpha1 = alpha(1:N1,:);
		alpha2 = alpha(N1+1:end,:);
        
         
        invG1 = G1*inv(G1'*G1); %#ok<MINV>
        alpha1 = invG1*alpha1;
        
        invG2 = G2*inv(G2'*G2);
        alpha2 = invG2*alpha2;        

	case 'full' % no kernel matrix decomposition (full KCCA)

		I = eye(N); Z = zeros(N);
		N0 = eye(N)-1/N*ones(N);

		% get kernel matrices (centered Gram matrix)

        
        
		K1 = km_kernel(X1,X1,kernel1{1},kernel1{2});
		K2 = km_kernel(X2,X2,kernel2{1},kernel2{2});

        K1_row_mean=mean(K1);K1_col_mean=mean(K1,2);
        K2_row_mean=mean(K2);K2_col_mean=mean(K2,2);
 		K1 = N0*km_kernel(X1,X1,kernel1{1},kernel1{2})*N0;
		K2 = N0*km_kernel(X2,X2,kernel2{1},kernel2{2})*N0;       
		% 3 GEV options, all of them are fairly equivalent

		% % option 1: standard Hardoon
% 		R = [Z K1*K2; K2*K1 Z];
% 		D = [K1*K1+reg*I Z; Z K2*K2+reg*I];
% 		R = R/2+R'/2;   % avoid numerical problems
% 		D = D/2+D'/2;   % avoid numerical problems

		% option 2: simplified Hardoon
		% R = [Z K2; K1 Z];
		% D = [K1+reg*I Z; Z K2+reg*I];
		% % R = R/2+R'/2;   % avoid numerical problems
		% % D = D/2+D'/2;   % avoid numerical problems

		% % option 3: Kettenring-like generalizable formulation
		R = 1/2*[K1 K2; K1 K2];
		D = [K1+reg*I Z; Z K2+reg*I];
        KK_largest=50;
		% solve generalized eigenvalue problem
		[alphas,betas] = eigs((R),(D),KK_largest);
% 		[betass,ind] = sort(real(diag(betas)));
        [r, i] = sort(real(diag(betas)),'descend');
        alphas=alphas(:,i);
        betas = betas(:,i);
       
        alpha=alphas;
%         alpha=alphas./(repmat(sqrt(sum(alphas.^2)),[size(alphas,1) 1])+eps);
		% expansion coefficients
		alpha1 = alpha(1:N,1:KK_largest);
		alpha2 = alpha(N+1:end,1:KK_largest);

        alpha1 = normalisekcca(alpha1,K1);
        alpha2 = normalisekcca(alpha2,K2);
        r = diag(alpha1'*K1'*K2*alpha2);
        
		% estimates of latent variable
		y1 = K1*alpha1;
		y2 = K2*alpha2;

end