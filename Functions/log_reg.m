function theta_c = log_reg(p , PHI, t_aug, theta_tilda)
%MM algorithm for logistic regression
%%
[~,d] = size(PHI);

Q = 1/4.*PHI'*diag(p)*PHI;

prb = @(theta_tilda) exp(PHI*theta_tilda)./(1 + exp(PHI*theta_tilda));

grad = @(theta_tilda) PHI'*((prb(theta_tilda)-t_aug).*p);

del = @(theta_tilda) (Q\-grad(theta_tilda));

delta = del(theta_tilda);

theta = theta_tilda + delta;

c=1;

while c==1
        
    if norm(theta-theta_tilda)>1e-2
        theta_tilda = theta;
        delta = del(theta_tilda);
        theta = theta_tilda + delta;
    else
        c = 0;
    end
    
    %theta_c = theta_tilda + delta;
    theta_c = theta;
end
%%
% [n, d] = size(PHI);
% 
% seed = 0; 
% 
% rng(seed);
% 
% w_old = randn(d,1);
% 
% sigmoid = @(a) 1./(1+exp(-a));
% 
% cnt = 1;
% while cnt==1
%     
%     arg = PHI*w_old;
%     
%     y = sigmoid(arg);
%     
%     R_tilda = p.*(y.*(1-y));
%     
%     R_tilda = R_tilda + (10^-5);
%     
%     z = PHI*w_old - (p.*(y-t_aug))./R_tilda;
%     
%     w_new = (PHI'*(R_tilda.*PHI))\(PHI'*(R_tilda.*z));
%     
%     %grad = PHI'*(p.*(sigmoid(PHI*w_new)-t_aug));
%     if norm(w_old-w_new)>0.005
%         w_old = w_new; 
%         cnt = 1;
%     else
%         cnt=0;
%     end
%     
% end