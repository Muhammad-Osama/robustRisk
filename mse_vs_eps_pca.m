%Numerical settings for fig 5-section 4.3 in paper
%% set seed
seed = 0;
rng(seed);
%%
%nos. of Montecarlo sims
Neps = 10;
epsi0 = linspace(0.05,0.95,Neps);
M = 100;
%data
n = 40; sigma_e = 0.25; nu = 1.5;
epsi = 0.5;
%number of prinicipal components to consider
r = 1; 
%equal probability for normal theta estimation
p = ones(n,1)./n;
%direction along which max variance
theta_true = [1;2]./sqrt(5);
%theta estimates over Montecarlo runs
theta_robust = zeros(2, M, Neps); theta_nrm = zeros(2,M, Neps);
angle_nrm = zeros(M, Neps); angle_rob = zeros(M, Neps);
%% begin Montecarlo runs
for neps = 1:Neps
    neps
for m=1:M
   %display run
   m
   %generate data
   [X, ~, ~] = dataGen_pca(n, epsi0(neps), sigma_e, nu);
   %initialize
   theta_ini = ini_pca(X,r);
   %obtain robust estimate
   theta_robust(:, m, neps) = robust_pca(X,theta_ini,r,epsi);
   angle_rob(m, neps) = 180/pi.*cos(theta_true'*theta_robust(:, m, neps));
   %obtain simple estimate
   theta_nrm(:, m, neps) = pca2D(X,p,r);
   angle_nrm(m, neps) = 180/pi.*cos(theta_true'*theta_nrm(:, m, neps));
   %theta_sever(:,m) = sever_pca(X,epsi,4);
end
end
%%
mis_error_nrm = 1 - abs(cosd(angle_nrm));
mis_error_rob = 1 - abs(cosd(angle_rob));
%%
avg_miss_err_nrm = mean(mis_error_nrm,1);
avg_miss_err_rob = mean(mis_error_rob,1);
%%
figure;
br = [165,42,42]; br = br./255;
plot(epsi0, avg_miss_err_nrm,'Color',br,'LineWidth',2); hold on; grid on;
gr = [0.1,0.7,0.2];
plot(epsi0, avg_miss_err_rob,'Color',gr, 'LineWidth',2);
plot([epsi epsi],[0, 0.3],'k--','LineWidth',2);
xlabel('$\epsilon$','interpreter','Latex');
ylabel('Avergae misalignment error','interpreter','Latex');
legend({'ERM','RRM','$\tilde{\epsilon}$'},'interpreter','Latex')
