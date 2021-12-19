% Numerical settings for figure 3a
%% set seed
seed = 0; rng(seed);
%%
%nos. of Montecarlo sims 
M = 100;
%%nos. of points
n = 40; 
%dimension of theta
d = 10;       
%range of covariates U[a,b]
a = -5; b = 5;       
%theta^{\star}
theta_true = ones(d,1);    
%actual percentage of outliers
epsi0 = 0.2;
%assumed percentage of outliers
epsi = 0.4;                 
%parameters for Huber to compare against
sigma0 = 1;
c1 = 1.345;  
c2 = 0.7317;
%t-distributed noise
nu = 1.5; sigma_e = 0.25;
%theta estimates over Montecarlo sims
theta_rrm = zeros(d,M); theta_erm = zeros(d,M); 
theta_sever = zeros(d,M); 
theta_huber1 = zeros(d, M); theta_huber2 = zeros(d, M);

%% begin Montecarlo sims
for m = 1:M
   %display Monecarlo run
   m
   %generate data3
   [x,y] = data_generator_linReg(n,theta_true,a,b,nu,sigma_e,epsi0);
   %initialize
   theta_ini = ini_linReg(x,y);
   %obtain robust estimate
   theta_rrm(:,m) = robust_linReg(x,y,theta_ini,epsi);
   %obtain simple LS estimate
   theta_erm(:,m) = (x'*x)\(x'*y);   
   %sever
   theta_sever(:,m) = sever_linReg(x,y,epsi,4);
   %theta_huber1(:,m) = hubreg(y,x,c1,theta_ini,sigma0);
   theta_huber2(:,m) = hubreg(y,x,c2,theta_ini,sigma0);
end

%% save workspace
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_linReg_1D.mat')
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_linReg_highDim.mat')
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_linReg_highDim_with_intercept.mat')
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_linReg_highDim_with_sever_new.mat')
%% calculate relative error
rel_err_rob = sum((theta_rrm-theta_true).^2,1)./sum(theta_true.^2);
rel_err_rob = sqrt(rel_err_rob);
rel_err_ls = sum((theta_erm-theta_true).^2,1)./sum(theta_true.^2);
rel_err_ls = sqrt(rel_err_ls);
rel_err_sever = sum((theta_sever-theta_true).^2,1)./sum(theta_true.^2);
rel_err_sever = sqrt(rel_err_sever);
%rel_err_huber1 = sum((theta_huber1-theta_true).^2,1)./sum(theta_true.^2);
%rel_err_huber1 = sqrt(rel_err_huber1);
rel_err_huber2 = sum((theta_huber2-theta_true).^2,1)./sum(theta_true.^2);
rel_err_huber2 = sqrt(rel_err_huber2);
%% box plot-relative error
categ = {'ERM','Huber','SEVER','RRM'};
ERROR = [rel_err_ls' rel_err_huber2' rel_err_sever' rel_err_rob'];

figure;
boxplot(ERROR,'Labels',categ,'symbol','','whisker',100)
grid on;
hold on;
scatter([1,2,3,4],mean(ERROR,1),'r','filled')
ylabel('$Relative~error$','interpreter','Latex');
ylim([0 0.15])
%%
%bwidth = 0.02;
%figure;
%br = [165,42,42]; br = br./255;
%histogram(rel_err_ls,'BinWidth',bwidth,'FaceAlpha',1,'FaceColor',br);grid on; hold on;
%or = [255,165,0]; or = or./255;
%histogram(rel_err_sever,'BinWidth',bwidth,'FaceAlpha',1,'FaceColor',or);
%gr = [0.1,0.7,0.2];
%histogram(rel_err_rob,'BinWidth',bwidth,'FaceAlpha',1,'FaceColor',gr); 
%legend({'$ERM$','$SEVER$','$RRM$'},'interpreter','Latex')
%xlabel('$\frac{||\theta^{\star}-\widehat{\theta}||_{2}}{||\theta^{\star}||_{2}}$','interpreter','Latex')
%xlabel('$Relative~error$','interpreter','Latex')
%ylabel('$Nos.~of~points$','interpreter','Latex')
%xlim([0 1])
%title(['$\epsilon_{o}~=~$' num2str(epsi0) '$,~\epsilon~=~$' num2str(epsi)],'interpreter','Latex');
%saveas(gcf,'C:\Osama_Uppsala\Robust project\Figures\Jpeg\linear regression\hist_highDim.jpg');
