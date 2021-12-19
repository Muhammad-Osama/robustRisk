function [cF_upp, cF_low] = bounds_dkw_inequality(loss,lstr,alpha)

d = length(loss);

epsilon = sqrt(log(2/alpha)/(2*d));

Fhat = empirical_cdf(loss,lstr);

cF_upp = 1 - Fhat + epsilon;
cF_low = 1 - Fhat - epsilon;
