function psi_hub_x = psi_huber(x,c)

n = length(x);

psi_hub_x = zeros(n,1);

for i=1:n
    if abs(x(i))<=c
        psi_hub_x(i) = x(i);
    else
        psi_hub_x(i) = c*signum(x(i));
    end
end