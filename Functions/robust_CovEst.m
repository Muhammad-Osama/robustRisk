function [Sigma_robust, mu_robust] = robust_CovEst(Z,mu_old,Sigma_old,epsi)

n = size(Z,1);

cnt=1;
while cnt==1
   alpha = alpha_CovEst(Z,mu_old,Sigma_old);
   %p_new = optimize_probability(alpha,epsi,n);
   p_new = my_barrier_opt_prb(alpha, epsi, n);
   [Sigma_new, mu_new] = CovEst(Z,p_new);
   if norm(Sigma_old-Sigma_new,'fro')/norm(Sigma_old,'fro')>0.01
      Sigma_old = Sigma_new;
   else
       cnt = 0;
   end
end
Sigma_robust = Sigma_new;
mu_robust = mu_new;