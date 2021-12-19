% Numerical settings for figure 3a
%% set seed
seed = 0; rng(seed);
%%
%nos. of Montecarlo sims 
M = 50;
%%nos. of points
n = 100; 
%dimension of theta
d = 10;       
%range of covariates U[a,b]
a = -5; b = 5;       
%theta^{\star}
theta_true = ones(d,1);    
%actual percentage of outliers
Neps = 5;
epsi0 = linspace(0.1,0.5,Neps);
%assumed percentage of outliers
epsi = 0.7;                 
%t-distributed noise
nu = 1.5; sigma_e = 0.25;
%theta estimates over Montecarlo sims
theta_rrm = zeros(d,M,Neps); 
%estimate of eps
eps_hat = zeros(M, Neps);
%true positive and false positive
prb_corr_det = zeros(M, Neps);
prb_false_det = zeros(M, Neps);
%threshold for weights
tau = 1e-4;

%% begin Montecarlo sims
for neps=1:Neps
   neps
for m = 1:M
   %display Monecarlo run
   m
   %generate data3
   [x, y, ind] = data_generator_linReg(n,theta_true,a,b,nu,sigma_e,epsi0(neps));
   %initialize
   theta_ini = ini_linReg(x,y);
   %obtain robust estimate
   [theta_rrm(:,m, neps), prb] = robust_linReg(x,y,theta_ini,epsi);
   % true positive
   prb_corr_det(m, neps) = sum(prb(ind==1)<tau)/sum(ind==1);
   % false positive
   prb_false_det(m, neps) = sum(prb(ind~=1) < tau)/sum(ind~=1);
   % eps estimate
   eps_hat(m, neps) = sum(prb<tau)./n;
end
end
%%
figure;
plot(epsi0, mean(prb_corr_det,1),'k-','LineWidth',2);  hold on;
plot(epsi0, mean(prb_false_det,1),'m-','LineWidth',2);
grid on;
legend({'True positive', 'False alarm'},'interpreter','Latex');
xlabel('$\epsilon$','interpreter','Latex');
ylabel('Probability','interpreter','Latex');
%%
figure;
scatter(1:Neps, epsi0,'ko', 'filled'); hold on; grid on;
boxplot(eps_hat,'Whisker', 0,'symbol','');
legend({'$\epsilon$'}, 'interpreter','Latex')
xlabel('$\epsilon$','interpreter','Latex');
ylabel('$\hat{\epsilon}$','interpreter','Latex');


