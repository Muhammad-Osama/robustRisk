function [Sigma_hat, mu_hat] = CovEst(Z,p)
%Z : n x d matrix
%mu : d x 1 vector
%p: n x 1 vector

mu_hat = Z'*p;

Sigma_hat = (Z-mu_hat')'*diag(p)*(Z-mu_hat');
