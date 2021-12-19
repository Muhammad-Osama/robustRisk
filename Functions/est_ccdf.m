function cFest_loss = est_ccdf(p, ls, loss)

n = length(ls);

ly_sort = sort(loss);

cFest_loss_func = @(lstr) (ly_sort>=lstr)'*p ;

%cFest_y = zeros(n,1);

cFest_loss = zeros(n,1);

for i=1:n
   %cFest_y(i) = 1 - cFest_loss_func(ly(ystr(i))); 
   cFest_loss(i) = cFest_loss_func(ls(i)); 
end    