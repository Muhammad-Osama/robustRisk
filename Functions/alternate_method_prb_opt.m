function p_new = alternate_method_prb_opt(alpha,epsilon)

%data size
n = length(alpha);

%initail values of dual variables dl = [beta; eta]
dl_old = [1; 1];

%entropy constraint R.H.S
H = log((1-epsilon)*n);

cnt = 1;

while (cnt==1)
    %initial estimate of probability
    p = exp((dl_old(1) - alpha)./dl_old(2)); 
    ind = p < eps;
    p(ind) = 0;
    %
    aux = p.*(dl_old(1) - alpha)./dl_old(2);
    %elements of 2 x 2 matrix
    a = sum(p); b = -sum(aux); c = -b; 
    psub = p(~ind); aux_sub = aux(~ind); d = -(1./psub)'*(aux_sub.^2);
    %matrix inverse
    Ainv = [d -b;-c a]./(a*d-b*c);
    %vector
    bvec = [a-1; sum(aux) - a + 1 + H];
    %update dual variables
    dl_new = dl_old - dl_old(2).*(Ainv*bvec)
    
    if norm(dl_new-dl_old)/norm(dl_old)<0.01
        cnt=0;
    else
        dl_old = dl_new;
    end
end

p_new = p;

