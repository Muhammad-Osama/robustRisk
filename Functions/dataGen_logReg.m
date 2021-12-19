function [Y, X, Yp, Yq, li] = dataGen_logReg(n, X, theta_true,theta1,theta2,epsilon)

%sigmoid function
sig = @(x) 1./(1+exp(-x));

%labels 0 or 1
Y = zeros(n,1);

%p(Y|X)
PHI = [ones(n,1) X];
p = sig(PHI*theta_true);
%u = rand(n,1);
Yp = p>0.5; %Yp=1 with probability 'p'

%q(Y|X)
Yq = zeros(n,1);
p1 = sig(PHI*theta1); p2 = sig(PHI*theta2);
li = p1>0.5 & p2>0.5; Yq(li) = 0; 
li = p1<=0.5 & p2>0.5; Yq(li) = 1;
li = p1<=0.5 & p2<=0.5; Yq(li) = 0;

%
u = rand(n,1);
li = u<epsilon;
Y(li) = Yq(li);
Y(~li) = Yp(~li);
