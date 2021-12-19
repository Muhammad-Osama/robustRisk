function p = optimize_probability(alpha,epsilon,n)

cvx_begin
     variable p(n)
     minimize (alpha'*p)
     subject to
     -sum(rel_entr(p,1))>=(log((1-epsilon)*n));
     ones(1,n)*p == 1;
     p >= 0;
cvx_end