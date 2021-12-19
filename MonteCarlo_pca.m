%Numerical settings for fig 5-section 4.3 in paper
%% set seed
seed = 0;
rng(seed);
%%
%nos. of Montecarlo sims
M = 100;
%data
n = 40; sigma_e = 0.25; nu = 1.5;
epsi0 = 0.2; epsi = 0.4;
%number of prinicipal components to consider
r = 1; 
%equal probability for normal theta estimation
p = ones(n,1)./n;
%direction along which max variance
theta_true = [1;2]./sqrt(5);
%theta estimates over Montecarlo runs
theta_robust = zeros(2,M); theta_nrm = zeros(2,M);
theta_sever = zeros(2,M);
%% begin Montecarlo runs
for m=1:M
   %display run
   m
   %generate data
   [X, ~, ~] = dataGen_pca(n, epsi0, sigma_e, nu);
   %initialize
   theta_ini = ini_pca(X,r);
   %obtain robust estimate
   theta_robust(:,m) = robust_pca(X,theta_ini,r,epsi);
   %obtain simple estimate
   theta_nrm(:,m) = pca2D(X,p,r);
   theta_sever(:,m) = sever_pca(X,epsi,4);
end
%% error vectors
%err_robust = theta_robust'-(theta_robust'*theta_true).*theta_true';
%err_nrm = theta_nrm'-(theta_nrm'*theta_true).*theta_true';
%err_sever = theta_sever'-(theta_sever'*theta_true).*theta_true';
%error l2-norm
%errRob = sqrt(sum(err_robust.^2,2));
%errNrm = sqrt(sum(err_nrm.^2,2));
%errSev = sqrt(sum(err_sever.^2,2));
%% save workspace
%save('C:\Osama_Uppsala\Robust project\Data\MonteCarlo_pca_latest_as_per_paper_with_sever.mat');
%% figure 5- misalignment error
alpha_erm = 180/pi.*acos((theta_nrm'*theta_true));%./(sqrt(sum(theta_nrm'.^2,2))*norm(theta_true)));
alpha_sev = 180/pi.*acos((theta_sever'*theta_true));%./(sqrt(sum(theta_sever'.^2,2))*norm(theta_true)));
alpha_rrm = 180/pi.*acos((theta_robust'*theta_true));%./(sqrt(sum(theta_robust'.^2,2))*norm(theta_true)));
%%
categ = {'ERM','SEVER','RRM'};
ERROR = [1-abs(cosd(alpha_erm)) 1-abs(cosd(alpha_sev)) 1-abs(cosd(alpha_rrm))];

figure;
boxplot(ERROR,'Labels',categ,'symbol','','whisker',1000);
grid on;
hold on;
scatter([1,2,3],mean(ERROR,1),'r','filled')
ylabel('$Misalignment~error$','interpreter','Latex')
ylim([0 0.1])
%%
%bin_width = 0.05;
%figure;
%histogram(errNrm,'BinWidth',bin_width,'FaceAlpha',1);grid on; hold on;

%histogram(errRob,'BinWidth',bin_width,'FaceAlpha',1);
%histogram(errSev,'BinWidth',bin_width,'FaceAlpha',1);
%xlabel('$||\widehat{\theta}-(\widehat{\theta}^{\top}\theta_{\star})\theta_{\star}||_{2}$','interpreter','Latex')
%ylabel('$Nos.~of~points$','interpreter','Latex');
%legend({'$ERM$','$RRM$','$SEVER$'},'interpreter','Latex')
%title(['$\epsilon_{o}~=~$' num2str(epsi0) '$,~\epsilon~=~$' num2str(epsi)],'interpreter','Latex');
%saveas(gcf,'C:\Osama_Uppsala\Robust project\Figures\Jpeg\pca\hist_normal_noise.jpg');

