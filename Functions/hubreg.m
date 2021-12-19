function theta_hub = hubreg(y,X,c,theta0,sigma0)

n = size(X,1);

alpha = c^2*(1-chi2cdf(c^2,1))+chi2cdf(c^2,3);

Xplus = (X'*X)\(X');

cnt = 1;

while cnt==1
    %update residual
    r = y-X*theta0;
    %update pesudo residual
    r_psi = psi_huber(r./sigma0,c).*sigma0;
    %update scale
    sigma = 1/sqrt(n*2*alpha).*norm(r_psi);
    %(re)update the pseudo residual
    r_psi = psi_huber(r./sigma,c).*sigma;
    %regress X on r_psi
    del = Xplus*r_psi;
    %update theta
    theta = theta0 + del;
    %stopping criteria
    if norm(theta-theta0)/norm(theta0)>1e-6
        sigma0 = sigma;
        theta0 = theta;
    else
        cnt = 0;
        theta_hub = theta;
    end
end