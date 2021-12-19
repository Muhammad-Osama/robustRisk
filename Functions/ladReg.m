function theta_lad = ladReg(y,X,theta0)
%Least absolute deviation (LAD) regeression 
%Taken from Zoubir Algorithm 3 page 46

cnt = 1;

n = size(X,1); 

w = zeros(n,1); 

sgn_r = zeros(n,1);

while cnt==1
   %updata residual
   r = y-X*theta0;
   li = abs(r)>(10^-6);
   %weights
   w(li) = 1./abs(r(li));
   w(~li) = 10^6;
   %evaluate signum function
   li2 = r==0;
   sgn_r(~li2) = r(~li2)./abs(r(~li2));
   sgn_r(li2) = 0;
   %evaluate update in theta
   del = (X'*diag(w)*X)\(X'*sgn_r);
   theta_lad = theta0 + del;
   %stopping criterion
   if norm(del)/norm(theta0)>1e-4
      theta0 = theta_lad;
   else
       cnt = 0;
   end
   
end
