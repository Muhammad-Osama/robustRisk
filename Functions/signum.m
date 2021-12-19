function signum_x = signum(x)

n = length(x);

signum_x = zeros(n,1);

for i=1:n
   if x(i)~=0 
   signum_x(i) = x(i)/abs(x(i));
   else
       signum_x(i) = 0;
   end
end