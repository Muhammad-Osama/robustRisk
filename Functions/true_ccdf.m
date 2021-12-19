function cFtrue = true_ccdf(cF,ystr)

n = length(ystr);

cFtrue = zeros(n,1);

for i=1:n
   cFtrue(i) = cF(ystr(i)); 
end