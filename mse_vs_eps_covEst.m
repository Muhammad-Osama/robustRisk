n = 50; d = 2; nu = 1.5; 
mu = zeros(d,1); Sigma_true = [1 0.8;0.8 1]; L_true = chol(Sigma_true,'lower');
Neps = 5;
eps0 =  linspace(0.05, 0.95, Neps); epsi = 0.5; p = ones(n,1)./n;
M = 50; 
Sigma_nrm = zeros(d,d,M, Neps); Sigma_rob = zeros(d,d,M, Neps); mu_nrm = zeros(d,M, Neps);
mu_rob = zeros(d,M, Neps);
err_nrm = zeros(M, Neps); err_rob = zeros(M, Neps); err_rob_mu = zeros(M, Neps);
seed = 0; rng(seed); 
%%
for neps=1:Neps
    neps
for m=1:M
    m
    %generate data
    [Z,Zp,Zq] = dataGen_CovEst(n,L_true,Sigma_true,mu,nu,eps0(neps));
    %normal estimation
    [Sigma_nrm(:,:,m,neps), mu_nrm(:,m,neps)] = CovEst(Z,p);
    err_nrm(m,neps) = sqrt(sum(sum((Sigma_nrm(:,:,m,neps)-Sigma_true).^2,1),2))./norm(Sigma_true,'fro');
    %robust estimation
    [Sigma_rob(:,:,m,neps),mu_rob(:,m,neps)] = robust_CovEst(Z ,mu_nrm(:,m), Sigma_nrm(:,:,m,neps),epsi);
    err_rob(m,neps) = sqrt(sum(sum((Sigma_rob(:,:,m,neps)-Sigma_true).^2,1),2))./norm(Sigma_true,'fro');
    err_rob_mu (m, neps) = norm(mu_rob(:,m,neps) - mu);
end
end
%% evaluate relative error
avg_err_nrm = mean(err_nrm,1);
avg_err_rob = mean(err_rob,1);

%% 
figure;
boxplot(err_rob); ylabel('Error in covariance');
%%
figure;
boxplot(err_rob_mu); ylabel('Error in mean');

%%
figure;
br = [165,42,42]; br = br./255;
plot(eps0, avg_err_nrm,'Color',br,'LineWidth',2); hold on; grid on;
gr = [0.1,0.7,0.2];
plot(eps0, avg_err_rob,'Color',gr, 'LineWidth',2);
plot([epsi epsi],[0, 20],'k--','LineWidth',2);
ylim([0 20])
xlabel('$\epsilon$','interpreter','Latex');
ylabel('Avergae relative error','interpreter','Latex');
legend({'ERM','RRM','$\tilde{\epsilon}$'},'interpreter','Latex')