function alpha = alpha_CovEst(Z,mu,Sigma_hat)

[~,d] = size(Z);

alpha = 0.5.*(d*log(2*pi) + log(det(Sigma_hat)) + sum((Z-mu').*(Sigma_hat\(Z-mu')')',2));