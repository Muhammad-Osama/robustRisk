function theta_hat = sever_linReg(x,y,epsi,r)
%based on paper SEVER: a robust meta-algorithm for stochastic optimization
%Ilias Diakonikolas et al., 2019

n = length(y);

%active set
S = 1:n;

%x and y corresponding to active set
xs = x(S,:); ys = y(S);
    
for m = 1:r

    %base learner: least-square or any other
    theta_hat = (xs'*xs)\(xs'*ys);
    
    %gradients
    G_ucen = -2.*(ys-xs*theta_hat).*xs;
    G_cen = G_ucen-mean(G_ucen,1);
    
    %top right singular vector
    [~,~,V] = svds(G_cen);
    v = V(:,1);
    
    %outlier scores
    tau = (G_cen*v).^2;
    
    %remove 'p' points with highest scores
    p = floor(epsi/2*size(xs,1));
    [~, idx] = sort(tau,'descend');
    
    %new active set
    S = idx(p+1:end); 
    
    xs = xs(S,:); ys = ys(S);
end
