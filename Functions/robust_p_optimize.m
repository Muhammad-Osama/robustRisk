function p = robust_p_optimize(ly,alpha,lo)

ly_sort = sort(ly);
d = length(ly);
L = ones(d);
L = triu(L,1);
f = -ly_sort; A = [L;-L]; 
[upp, low] = bounds_dkw_inequality(ly,ly_sort,alpha);
b = [upp; -low];
Aeq = ones(1,d); beq = 1; lb = zeros(d,1);
%p = linprog(f,A,b,Aeq,beq,lb);

B = (ly_sort>=lo); 
pn_lo = sum(B)/d;
[upp_lo,~] = bounds_dkw_inequality(ly,lo,alpha);
beta = (upp_lo/pn_lo - 1)/2;
%p_hat Pr(L>=l) (adding Pr(L=l))
cFhat = 1-empirical_cdf(ly,ly_sort) + 1/d;
%upper bound for Pr(L>=l) (adding Pr(L=l))
upp = upp + 1/d; 
upp(upp>1)=1;
%lower bound 
new_lb = (upp + cFhat)/2;
%Pr(L>=l) as per estimate C*p
C = triu(ones(d));
C = [C;-C];
c = [upp;-new_lb];

cvx_begin
    variable p(d)
    maximize (sum(entr(p)));
    subject to
        %A*p<=b;         %CI_alpha
        C*p<=c;
        Aeq*p==beq;     %sum(p)=1
        p>=0;
        %B'*p>=((1+beta)*pn_lo);  %Pr{L>=l0;robust}>=(1+beta)Pr{L>=l0;empirical}
cvx_end

        