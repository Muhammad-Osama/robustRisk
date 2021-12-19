function [X, Xp, Xq] = dataGen_pca(n, eps0, sigma_e, nu)

X = zeros(n,2);

%P(x,y)
xp = randn(n,1); 
yp = 2.*xp + sigma_e.*randn(n,1);%trnd(nu,n,1);
Xp = [xp yp];

%Q(x,y)
Xq = mvtrnd(eye(2),nu,n); %sigma_e.*randn(n,2);

u = rand(n,1); li = u<eps0;

X(li,:) = Xq(li,:);

X(~li,:) = Xp(~li,:);


