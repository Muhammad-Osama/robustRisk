%Numerical settings for figure 4: Note that running M = 100 montecarlo
%simulation takes time. But to reproduce the results in fig 4c, one needs
%to run 100 montecarlo sims. Also the signle realization in figure 4b,
%corresponds to the last i.e. the 100^th montecarlo run. One can set M=1
%and run section titled figure 4b to get an idea
%% set seed
seed = 0;
rng(seed);
%% 
%nos. of MonteCarlo sims
M = 25;
%theta_str
theta_true = [-1;1;1]; 
m_true = -theta_true(2)/theta_true(3); c_true = theta_true(1)/theta_true(2);
%dimension of theta
d = 3; 
%nos. of points
n = 100;
theta_tilda = zeros(d,1);
%eps
Neps = 10;
eps0 = linspace(0.05,0.5,Neps); 
%eps_bar
epsi = 0.25;
%theta estimates over MonteCarlo runs
theta_robust = zeros(d,M, Neps); theta_nrm = zeros(d,M, Neps); 
angle_nrm = zeros(M, Neps);
angle_rob = zeros(M, Neps);
%theta_sever1 = zeros(d,M); %theta_sever2 = zeros(d,M);
%% start Montecarlo sims
for neps = 1: Neps
    neps
for m=1:M
    m
    %display
    %generate data p(Y|X)
    %[Y, X, Yp, Yq, li] = dataGen_logReg(n,X,theta_true,theta1,theta2,eps0);
    [Y,X] = dataGen2_logReg(n,eps0(neps));
    PHI = [ones(n,1) X];
    %normal log regression
    theta_nrm(:,m, neps) = log_reg(1/n.*ones(n,1) , PHI, Y, theta_tilda);
    %robust log regression
    theta_robust(:,m, neps) = robust_logReg(PHI,Y,1/n.*ones(n,1),theta_tilda,epsi);
    %sever
    %theta_sever1(:,m) = sever_logReg(PHI,Y,theta_tilda,epsi,4);
    %theta_sever2(:,m) = sever_logReg(PHI,Y,theta_tilda,epsi,3);
    angle_nrm(m, neps) = 180/pi .* acos((theta_true'*theta_nrm(:,m, neps))/(norm(theta_true)*norm(theta_nrm(:, m, neps))));
    angle_rob(m, neps) = 180/pi .* acos((theta_true'*theta_robust(:,m, neps))/(norm(theta_true)*norm(theta_robust(:, m, neps))));
end
end
%% save workspace
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_logReg_working.mat');
%save('C:\Osama_Uppsala\Robust project\Data\logReg_single_realization.mat');
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_logReg_working_with_sever_new.mat');
%save('C:\Osama_Uppsala\Robust_project\Data\MonteCarlo_logReg_newDataGen.mat');
%%
avg_angle_nrm = mean(angle_nrm, 1);
avg_angle_rob = mean(angle_rob, 1);

%%
figure;
br = [165,42,42]; br = br./255;
plot(eps0,avg_angle_nrm,'-','LineWidth',2,'Color',br); grid on; hold on; 
%plot(eps0,rmse_lad,'-','LineWidth',2);
%plot(eps0,rmse_hub1,'-^','LineWidth',2);
%plot(eps0,rmse_hub2,'-','LineWidth',2);
%or = [255,165,0]; or = or./255;
%plot(eps0,rmse_sever,'-','LineWidth',2,'Color',or);
gr = [0.1,0.7,0.2];
plot(eps0,avg_angle_rob,'-','LineWidth',2,'Color',gr);
%ylabel('$E\Big[\frac{||\widehat{\theta}-\theta_{\star}||_{2}^{2}}{||\theta_{\star}||_{2}^{2}}\Big]$','interpreter','Latex')
plot([epsi epsi], [0,180],'k--', 'LineWidth', 2);
ylabel('$Average~angle$','interpreter','Latex')
xlabel('$\epsilon$','interpreter','Latex')
%legend({'ERM','Huber','SEVER','RRM'},'interpreter','Latex')
legend({'ERM','RRM','$\tilde{\epsilon}$'},'interpreter','Latex')