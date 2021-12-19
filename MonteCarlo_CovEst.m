n = 50; d = 2; nu = 1.5; 
mu = zeros(d,1); Sigma_true = [1 0.8;0.8 1]; L_true = chol(Sigma_true,'lower');
eps0 = 0.2; epsi = 0.3; p = ones(n,1)./n;
M = 100; 
Sigma_nrm = zeros(d,d,M); Sigma_rob = zeros(d,d,M); mu_nrm = zeros(d,M);
mu_rob = zeros(d,M);
Sigma_sev = zeros(d,d,M); mu_sev = zeros(d,M);
seed = 0; rng(seed); 
%%
for m=1:M
    m
    %generate data
    [Z,Zp,Zq] = dataGen_CovEst(n,L_true,Sigma_true,mu,nu,eps0);
    %normal estimation
    [Sigma_nrm(:,:,m), mu_nrm(:,m)] = CovEst(Z,p);
    %robust estimation
    [Sigma_rob(:,:,m),mu_rob(:,m)] = robust_CovEst(Z,mu_nrm(:,m),Sigma_nrm(:,:,m),epsi);
    [Sigma_sev(:,:,m),mu_sev(:,m)] = sever_CovEst(Z,epsi,3);
end
%% evaluate relative error
err_nrm = sqrt(sum(sum((Sigma_nrm-Sigma_true).^2,1),2))./norm(Sigma_true,'fro');
err_rob = sqrt(sum(sum((Sigma_rob-Sigma_true).^2,1),2))./norm(Sigma_true,'fro');
err_sev = sqrt(sum(sum((Sigma_sev-Sigma_true).^2,1),2))./norm(Sigma_true,'fro');
%% fig 6 of paper
categ = {'ERM','SEVER','RRM'};
ERROR = [err_nrm(:) err_sev(:) err_rob(:)];

figure;
boxplot(ERROR,'Labels',categ,'symbol','','whisker',100)
grid on; 
hold on;
scatter([1,2,3],mean(ERROR,1),'r','filled')
ylabel('$Relative~error$','interpreter','Latex');
ylim([0 3])
%% save workspace
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_CovEst');
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_CovEst_2');
%save('C:\Osama_Uppsala\Robust_project\Data\MonteCarlo_CovEst_unknown_mean_with_sever.mat')
%% Error histogram
%bin_width = 0.5;
%histogram(err_nrm,'BinWidth',bin_width,'FaceAlpha',1); grid on; hold on;
%histogram(err_sev,'BinWidth',bin_width,'FaceAlpha',1);
%histogram(err_rob,'BinWidth',bin_width,'FaceAlpha',1);
%xlabel('$\frac{||\widehat{\Sigma}-\Sigma_{\star}||_{F}}{||\Sigma_{\star}||_{F}}$','interpreter','Latex')
%ylabel('$Nos.~of~points$','interpreter','Latex');
%legend({'$ERM$','$SEVER$','$RRM$'},'interpreter','Latex');
%title('$Covariance~Estimation$','interpreter','Latex')
%xlim([0 50])
%%
%figure;
%scatter(Zp(:,1),Zp(:,2),'r','filled'); grid on; hold on;
%scatter(Zq(:,1),Zq(:,2),'b','filled');
%scatter(Z(:,1),Z(:,2),'k','filled');