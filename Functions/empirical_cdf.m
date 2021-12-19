function Femp = empirical_cdf(y,ystr)

n = length(ystr);

Femp = zeros(n,1);

for i=1:n
   Femp(i) = 1/length(y).*sum(y<=ystr(i)); 
end


