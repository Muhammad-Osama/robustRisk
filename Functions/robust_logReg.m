function theta_new = robust_logReg(PHI,y,p_old,theta_tilda,epsilon)

n = size(PHI,1);
cnt = 1;

% p_old = zeros(n,1);
% neff = ceil((1-epsilon)*n);
% idx = 1:n;
% idx_new = datasample(idx,neff,'Replace',false);
% p_old(idx_new) = 1/neff;
theta_old = log_reg(p_old , PHI, y, theta_tilda);


%% optimize
while cnt==1
    
   alpha = -y.*(PHI*theta_old) + log(1+exp(PHI*theta_old));
   
   %p_new = optimize_probability(alpha,epsilon,n);
   
   p_new = my_barrier_opt_prb(alpha, epsilon, n);
   
   theta_new = log_reg(p_new , PHI, y, theta_tilda);
   
   %stopping criteria 
   if norm(theta_new-theta_old)/norm(theta_old)>0.01
        cnt = 1;
        theta_old = theta_new;
    else
        cnt = 0;
    end
end