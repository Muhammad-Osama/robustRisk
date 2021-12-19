function theta_hat = sever_logReg(PHI,y,theta_tilda,epsi,r)
%based on paper SEVER: a robust meta-algorithm for stochastic optimization
%Ilias Diakonikolas et al., 2019

n = length(y);

%active set
S = 1:n;

%x and y corresponding to active set
PHIs = PHI(S,:); ys = y(S);
    
for m = 1:r
    
    
    %base learner: logistic regression
    theta_hat = log_reg(1/size(PHIs,1).*ones(size(PHIs,1),1) , PHIs, ys, theta_tilda);
    
    %gradients
    G_ucen = (-ys.*(PHIs*theta_hat) + 1./(1+exp(-PHIs*theta_hat))).*PHIs;
    G_cen = G_ucen-mean(G_ucen,1);
    %
    G_cen  = G_cen + 1e-4.*eye(size(G_cen));
    
    %top right singular vector
    [~,~,V] = svds(G_cen);
    v = V(:,1);
    
    %outlier scores
    tau = (G_cen*v).^2;
    
    %remove 'p' points with highest scores
    p = floor(epsi/2*size(PHIs,1));
    [~, idx] = sort(tau,'descend');
    
    %new active set
    S = idx(p+1:end); 
    
    PHIs = PHIs(S,:); ys = ys(S);
end
