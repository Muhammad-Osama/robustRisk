function theta_ini = ini_pca(X,r)

n = size(X,1);

%equal probabilites to start
p = ones(n,1)./n;

%theta_ini: solution of pca at 'p'
%theta_ini = pca2D(X_aug,p_old,r);

%or fixed initial theta
theta_ini = [0.1;1];

theta_ini = theta_ini./norm(theta_ini);


