function C = pca2D(X,p,r)

%no need to make it zero mean since it is already a draw from normal
P = diag(p);
Csamp = X'*(P.^2)*X;
[eigVec,eigVal] = eig(Csamp);
eigVal = diag(eigVal); 
[~,idx] = sort(eigVal,'descend');
sorted_eigVec = eigVec(:,idx);
C = sorted_eigVec(:,1:r);