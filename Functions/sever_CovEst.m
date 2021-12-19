function [Sigma_hat, mu_hat] = sever_CovEst(Z,epsi,r)
%based on paper SEVER: a robust meta-algorithm for stochastic optimization
%Ilias Diakonikolas et al., 2019

[n,d] = size(Z);

%active set
S = 1:n;

Zs = Z(S,:);

for m = 1:r
    
    %max. likelihood estimate usign active set
    mu_hat = mean(Zs,1);
    Sigma_hat = 1/size(Zs,1).*(Zs-mu_hat)'*(Zs-mu_hat);
   
    %gradients
    G = zeros(size(Zs,1),d+d^2);
    for q = 1:size(Zs,1)
        G(q,1:d) = (Sigma_hat\(mu_hat'-Zs(q,:)'))';
        SampCov = (Zs(q,:)'- mu_hat')*(Zs(q,:)- mu_hat);
        dSigma = 0.5.*Sigma_hat\(eye(d)-SampCov/Sigma_hat);
        dSigma = dSigma(:)';
        G(q,d+1:end) = dSigma;
    end
    G_cen = G-mean(G,1);
    
    %top right singular vector
    [~,~,V] = svds(G_cen);
    v = V(:,1);
    
    %outlier scores
    tau = (G_cen*v).^2;
    
    %remove 'p' points with highest scores
    p = floor(epsi/2*size(Zs,1));
    [~, idx] = sort(tau,'descend');
    
    %new active set
    S = idx(p+1:end); 
    
    Zs = Zs(S,:);
end

mu_hat = mu_hat';
