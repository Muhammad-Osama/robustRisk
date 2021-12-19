function theta_hat = sever_pca(X,epsi,r)

n = size(X,1);

%active set index
S = 1:n;

%select data corresponding to active set
Xs = X(S,:);
    
for m = 1:r
    
    %obtain solution by normal PCA
    C = pca(Xs);
    theta_hat = C(:,1);
    
    %gradients
    G_ucen = -2.*((Xs*theta_hat).*Xs);
    G_cen = G_ucen-mean(G_ucen,1);
    
    %top right singular vector
    [~,~,V] = svds(G_cen);
    v = V(:,1);
    
    %outlier scores
    tau = (G_cen*v).^2;
    
    %remove 'p' points with highest scores
    p = floor(epsi/2*size(Xs,1));
    [~, idx] = sort(tau,'descend');
    
    %new active set
    S = idx(p+1:end); 
    
    Xs = Xs(S,:);
   
end