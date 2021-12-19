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
M = 10;
%theta_str
theta_true = [-1;1;1]; 
m_true = -theta_true(2)/theta_true(3); c_true = theta_true(1)/theta_true(2);
%dimension of theta
d = 3; 
%nos. of points
n = 100;
theta_tilda = zeros(d,1);
%eps
eps0 = 0.05; 
%eps_bar
epsi = 0.3;
%theta estimates over MonteCarlo runs
theta_robust = zeros(d,M); theta_nrm = zeros(d,M); 
theta_sever1 = zeros(d,M); %theta_sever2 = zeros(d,M);
%% start Montecarlo sims
for m=1:M
    %display
    m
    %generate data p(Y|X)
    %[Y, X, Yp, Yq, li] = dataGen_logReg(n,X,theta_true,theta1,theta2,eps0);
    [Y,X] = dataGen2_logReg(n,eps0);
    PHI = [ones(n,1) X];
    %normal log regression
    theta_nrm(:,m) = log_reg(1/n.*ones(n,1) , PHI, Y, theta_tilda);
    %robust log regression
    theta_robust(:,m) = robust_logReg(PHI,Y,1/n.*ones(n,1),theta_tilda,epsi);
    %sever
    theta_sever1(:,m) = sever_logReg(PHI,Y,theta_tilda,epsi,4);
    %theta_sever2(:,m) = sever_logReg(PHI,Y,theta_tilda,epsi,3);
end
%% save workspace
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_logReg_working.mat');
%save('C:\Osama_Uppsala\Robust project\Data\logReg_single_realization.mat');
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_logReg_working_with_sever_new.mat');
%save('C:\Osama_Uppsala\Robust_project\Data\MonteCarlo_logReg_newDataGen.mat');
%% compute slopes and intercepts of hyperplanes and rel error
m_rob = -theta_robust(2,:)./theta_robust(3,:); c_rob = -theta_robust(1,:)./theta_robust(3,:);
m_nrm = -theta_nrm(2,:)./theta_nrm(3,:); c_nrm = -theta_nrm(1,:)./theta_nrm(3,:);
m_sever1 = -theta_sever1(2,:)./theta_sever1(3,:); c_sever1 = -theta_sever1(1,:)./theta_sever1(3,:);
%m_sever2 = -theta_sever2(2,:)./theta_sever2(3,:); c_sever2 = -theta_sever2(1,:)./theta_sever2(3,:);
%rel_err_rob  = sqrt(sum((theta_robust-theta_true).^2,1))./norm(theta_true);
%rel_err_nrm  = sqrt(sum((theta_nrm-theta_true).^2,1))./norm(theta_true);
%%
%c_err_nrm = c_true-c_nrm;
%c_err_rob = c_true-c_rob;
%c_err_sever1 = c_true-c_sever1;
%c_err_sever2 = c_true-c_sever2;
%%
%m_err_nrm = m_true-m_nrm;
%m_err_rob = m_true-m_rob;
%m_err_sever1 = m_true-m_sever1;
%m_err_sever2 = m_true-m_sever2;
%% box plot of deviation in angle - figure 4c
alpha_erm = 180/pi.*acos((theta_nrm'*theta_true)./(sqrt(sum(theta_nrm'.^2,2))*norm(theta_true)));
alpha_sev = 180/pi.*acos((theta_sever1'*theta_true)./(sqrt(sum(theta_sever1'.^2,2))*norm(theta_true)));
alpha_rrm = 180/pi.*acos((theta_robust'*theta_true)./(sqrt(sum(theta_robust'.^2,2))*norm(theta_true)));

categ = {'ERM','SEVER','RRM'};
ERROR = [alpha_erm alpha_sev alpha_rrm];

idx1 = ~isnan(ERROR(:,3));

idx2 = ~isnan(ERROR(:,2));

idx = idx1&idx2;

ERROR_sub = ERROR(idx,:);

figure;
boxplot(ERROR,'Labels',categ,'symbol','','whisker',1000);
grid on;
hold on;
scatter([1,2,3],mean(ERROR_sub,1),'r','filled')
ylabel('$Angle~in~degrees$','interpreter','Latex')
%ylim([0 40])
%% figure 4b - hyperlanes with data single realization
np = floor((1-eps0)*n);
nq = n-np;
Yp = Y(1:np); Yq = Y(np+1:end);
Xp = X(1:end,:); Xq = X(np+1:end,:);
a = -5; b = 5;

figure;
scatter(Xp(Yp==1,1),Xp(Yp==1,2),'go','filled'); hold on; grid on; box on;
scatter(Xp(Yp==0,1),Xp(Yp==0,2),'bo','filled');
scatter(Xq(Yq==1,1),Xq(Yq==1,2),50,'g*');
scatter(Xq(Yq==0,1),Xq(Yq==0,2),50,'b*');
%
xax = linspace(a,b,10)';
%
yax = xax.*m_nrm(end) + c_nrm(end);
br = [165,42,42]; br = br./255;
plot(xax,yax,'Color',br,'LineWidth',2);
%
yax = xax.*m_sever1(end) + c_sever1(end);
or = [50,165,10]; or = or./255;
plot(xax,yax,'k--','LineWidth',2);
%
yax = xax.*m_rob(end) + c_rob(end);
plot(xax,yax,'Color','r','LineWidth',2);
%legend({'$True~plane$','$Inliers$','$Inliers$','$Outliers$','$Outliers$','$Normal$','$Robust$'},'interpreter','Latex')
xlabel('$x_{1}$','interpreter','Latex')
ylabel('$x_{2}$','interpreter','Latex')
ylim([-5 5])
%% rel error histograms
%bin_width = 0.15;
%figure;
%br = [165,42,42]; br = br./255;
%histogram(c_err_nrm,'BinWidth',bin_width,'FaceAlpha',1,'FaceColor',br); grid on; hold on;
%or = [255,165,0]; or = or./255;
%histogram(c_err_sever1,'BinWidth',bin_width,'FaceAlpha',1,'FaceColor',or);
%yl = [255,255,0]; yl = yl./255;
%histogram(c_err_sever2,'BinWidth',bin_width,'FaceAlpha',1,'FaceColor',yl);
%gr = [0.1,0.7,0.2];
%histogram(c_err_rob,'BinWidth',bin_width,'FaceAlpha',1,'FaceColor',gr);
%legend({'$ERM$','$SEVER$','$RRM$'},'interpreter','Latex')
%xlabel('$Error~in~y-intercept$','interpreter','Latex')
%ylabel('$Nos.~of~points$','interpreter','Latex')
%saveas(gcf,'C:\Osama_Uppsala\Robust project\Figures\Jpeg\log regression\hist.jpg')
%saveas(gca,'C:\Osama_Uppsala\Robust project\Overleaf\figs\logReg2D_hist.eps','epsc');

%% robust hyperplanes
figure;
xax = linspace(a,b,10)';
yax = xax.*m_rob + c_rob;
plot(xax,yax); hold on; grid on;
plot(xax,m_true.*xax + c_true,'k','LineWidth',2);
title(['$Hyperplanes~robust~\epsilon=$' num2str(eps0) '$,~\widetilde{\epsilon}=$' num2str(epsi)],'interpreter','Latex')
ylim([-5 5])
%saveas(gcf,'C:\Osama_Uppsala\Robust project\Figures\Jpeg\log regression\robust_planes.jpg')
%% normal hyperplanes
figure;
xax = linspace(a,b,10)';
yax = xax.*m_nrm + c_nrm;
plot(xax,yax); hold on; grid on;
plot(xax,m_true.*xax + c_true,'k','LineWidth',2);
title(['$Hyperplanes~normal~\epsilon=$' num2str(eps0) '$,~\widetilde{\epsilon}=$' num2str(epsi)],'interpreter','Latex')
ylim([-5 5])
%saveas(gcf,'C:\Osama_Uppsala\Robust project\Figures\Jpeg\log regression\normal_planes.jpg')
%%  sever hyperplanes
figure;
xax = linspace(a,b,10)';
yax = xax.*m_sever1 + c_sever1;
plot(xax,yax); hold on; grid on;
plot(xax,m_true.*xax + c_true,'k','LineWidth',2);
title(['$Hyperplanes~normal~\epsilon=$' num2str(eps0) '$,~\widetilde{\epsilon}=$' num2str(epsi)],'interpreter','Latex')
ylim([-5 5])
%saveas(gcf,'C:\Osama_Uppsala\Robust project\Figures\Jpeg\log regression\normal_planes.jpg')
