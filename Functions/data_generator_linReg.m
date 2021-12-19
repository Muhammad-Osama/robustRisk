function [x, y, li] = data_generator_linReg(n, theta_true, a, b, nu, sigma_e, epsilon)

d = size(theta_true,1);

y = zeros(n,1);

x = [ones(n,1) (b-a).*rand(n,d-1)- b];

u = rand(n,1);

noise_hev = trnd(nu,n,1); 

noise_nrm = sigma_e.*randn(n,1);

%with probability epsilon
li = u<epsilon;

eps = sum(li)/n;

%draw samples from Q(y|x)
y (li) = x(li,:)*theta_true + noise_hev(li);

%otherwise draw samples from P(y|x)
y(~li) = x(~li,:)*theta_true + noise_nrm(~li);
