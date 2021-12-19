%Numerical settings for figure 3b- Reduce montecarlo runs to M = 10 for the
%script to take small amount of time to run
%% set seed
seed = 0;
rng(seed);
%%
%varying eps0 percentage of outliers
Neps0 = 10;
eps0 = linspace(0.01,0.9,Neps0)';
%nos. of Montecarlo sims per eps0 
M = 200;
%nos. of points
n = 100; 
%dimension of theta
d = 10;       
%range of covariates U[a,b]
a = -5; b = 5;       
%theta^{\star} 
theta_true = ones(d,1);     
%assumed percentage of outliers
epsi = 0.5;            
%parameters for Huber estimate
c1 = 1.345;                 
c2 = 0.7317;                
sigma0 = 1;                 
%t-distributed noise
nu = 2.5; sigma_e = 0.25;   %for nu>2, MSE is defined
%theta estimates over Montecarlo sims
theta_robust = zeros(d,M,Neps0); theta_ls = zeros(d,M,Neps0); 
%theta_lad = zeros(d,M,Neps0); theta_hub_1 = zeros(d,M,Neps0);
%theta_hub_2 = zeros(d,M,Neps0); 
%theta_sever = zeros(d,M,Neps0);
%vary eps0
%%
tic;
for r = 1:Neps0
    %display
    r
    %begin Montecarlo sims
    for m = 1:M
        %display Monecarlo run
        m
        %generate data3
        [X,y] = data_generator_linReg(n,theta_true,a,b,nu,sigma_e,eps0(r));
        %initialize
        theta_ini = ini_linReg(X,y);
        %obtain robust estimate using our method
        theta_robust(:,m,r) = robust_linReg(X,y,theta_ini,epsi);
        %least absolute deviation
        %theta_lad(:,m,r) = ladReg(y,X,theta_ini);
        %huber regression with c = c1
        %theta_hub_1(:,m,r) = hubreg(y,X,c1,theta_ini,sigma0);
        %huber regression with c = c2
        %theta_hub_2(:,m,r) = hubreg(y,X,c2,theta_ini,sigma0);
        %obtain simple LS estimate
        theta_ls(:,m,r) = (X'*X)\(X'*y);
        %sever
        %theta_sever(:,m,r) = sever_linReg(X,y,epsi,4);
    end
end
fin = toc;
%% save workspace
%save('C:\Osama_Uppsala\Robust_project\Data\MonteCarlo_linReg_MSEvsEps_with_sever_new2020.mat')
%save('C:\Osama_Uppsala\Robust_project\Data\MonteCarlo_linReg_MSEvsEps_with_sever_new2020_2.mat')
%% relative error squared
nrm2_theta_true = (norm(theta_true).^2);
mse_ls = mean(sum((theta_ls-theta_true).^2,1),2); rmse_ls = mse_ls(:)./nrm2_theta_true;
mse_rob = mean(sum((theta_robust-theta_true).^2,1),2); rmse_rob = mse_rob(:)./nrm2_theta_true;
%mse_hub1 = mean(sum((theta_hub_1-theta_true).^2,1),2); rmse_hub1 = mse_hub1(:)./nrm2_theta_true;
%mse_hub2 = mean(sum((theta_hub_2-theta_true).^2,1),2); rmse_hub2 = mse_hub2(:)./nrm2_theta_true;
%mse_lad = mean(sum((theta_lad-theta_true).^2,1),2); rmse_lad = mse_lad(:)./nrm2_theta_true;
%mse_sever = mean(sum((theta_sever-theta_true).^2,1),2); rmse_sever = mse_sever(:)./nrm2_theta_true;
%% sqrt of relative error
rmse_ls = sqrt(rmse_ls);
rmse_rob = sqrt(rmse_rob);
%rmse_hub1 = sqrt(rmse_hub1);
%rmse_hub2 = sqrt(rmse_hub2);
%rmse_lad = sqrt(rmse_lad);
%rmse_sever = sqrt(rmse_sever);
%%
figure;
br = [165,42,42]; br = br./255;
plot(eps0,rmse_ls,'-','LineWidth',2,'Color',br); grid on; hold on; 
%plot(eps0,rmse_lad,'-','LineWidth',2);
%plot(eps0,rmse_hub1,'-^','LineWidth',2);
%plot(eps0,rmse_hub2,'-','LineWidth',2);
%or = [255,165,0]; or = or./255;
%plot(eps0,rmse_sever,'-','LineWidth',2,'Color',or);
gr = [0.1,0.7,0.2];
plot(eps0,rmse_rob,'-','LineWidth',2,'Color',gr);
%ylabel('$E\Big[\frac{||\widehat{\theta}-\theta_{\star}||_{2}^{2}}{||\theta_{\star}||_{2}^{2}}\Big]$','interpreter','Latex')
plot([epsi epsi], [0,0.18],'k--', 'LineWidth', 2);
ylabel('$Average~relative~error$','interpreter','Latex')
xlabel('$\epsilon$','interpreter','Latex')
%legend({'ERM','Huber','SEVER','RRM'},'interpreter','Latex')
legend({'ERM','RRM','$\tilde{\epsilon}$'},'interpreter','Latex')