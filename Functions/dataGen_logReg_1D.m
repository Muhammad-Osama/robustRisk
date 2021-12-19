function [Y,li,Yp,Yq] = dataGen_logReg_1D(n,PHI,theta_true,r, eps0)

Y = zeros(n,1);

sig = @(x) 1./(1+exp(-x));

%samples from p_o(y|x)
p = sig(PHI*theta_true);
u = rand(n,1);
Yp = u<p;
%samples from q(y|x)
Yq = zeros(n,1);

li = PHI(:,2)>0 & PHI(:,2)<2; Yq(li) = 1; 
li = PHI(:,2)>=2; Yq(li) = 0;
li = PHI(:,2)<=0 & PHI(:,2)>-0.5; Yq(li) = 1;
li = PHI(:,2)<=-0.5; Yq(li) = 0;
%Yq = abs(PHI(:,2))>r;

u = rand(n,1);
li = u<eps0;
Y(li) = Yq(li);
Y(~li) = Yp(~li);