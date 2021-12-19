function theta_ini = ini_linReg(x_aug,y_aug)

[n,d] = size(x_aug);
p_old = ones(n,1)./n;
%initial theta as the solution of WLS at p_old
theta_ini  = (x_aug'*(p_old.*x_aug))\(x_aug'*(p_old.*y_aug));
%or random
%theta_ini = randn(d,1);