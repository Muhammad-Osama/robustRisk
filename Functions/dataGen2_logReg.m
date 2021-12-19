function [Y, X] = dataGen2_logReg(n, eps0)

np = floor((1-eps0)*n);

%samples from p(z)
C = [0.5^2 0.5*0.5*-0.99;0.5*0.5*-0.99 0.5^2];
L = chol(C,'lower');
xvec_p = L*randn(2,np) + [0.5 ; 0.5];
xvec_p = xvec_p';

%true separating plane
m0 = -1; c0 = 1; 
%label
yp = xvec_p(:,2)>= xvec_p(:,1)*m0+c0;

%samples form q(z)
nq = n - np;
xvec_q = 0.1*randn(nq,2) + [0.5 1.25];
yq = zeros(nq,1); 

Y = [yp; yq]; X = [xvec_p;xvec_q];

