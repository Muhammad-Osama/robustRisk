function theta_new = robust_pca(X_aug, theta_old, r, epsilon)

n = size(X_aug,1);

cnt = 1;
while cnt==1
    %n x r matrix of projection coefficients of each of the n points
    U = X_aug*theta_old;
    %n x 1 vector of reconstruction error for each of the n points
    alpha = sum(X_aug.^2,2)-sum(U.^2,2);
    %optimize p to minimize loss under entropy constraint
    %p_new = optimize_probability(alpha,epsilon,n);
    p_new = my_barrier_opt_prb(alpha, epsilon, n);
    %new eigenvectors
    theta_new = pca2D(X_aug,p_new,r);
    %stopping criterion
    if norm(theta_new-theta_old)/norm(theta_old)>0.01
        cnt = 1;
        theta_old = theta_new;
    else
        cnt = 0;
    end
end