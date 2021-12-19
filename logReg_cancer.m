%% read data
filename = 'C:\Osama_Uppsala\Robust_project\Real data\breast_cancer_wisconsin.csv';

data = csvread(filename);

X = data(:,2:end-1);

Y = data(:,end);

Y(Y==2) = 0; Y(Y==4) = 1;

%% Train and test data

sig = @(a) 1./(1+exp(-a));

seed = 0; rng(seed);

n = length(Y);

idx = 1:n;

ntrain = floor(0.6*n);

[Ytrain, idx_train] = datasample(Y,ntrain,'Replace',false);

Xtrain = X(idx_train,:);

lic_train = ismember(idx,idx_train);

lic_test = ~lic_train;

idx_test = idx(lic_test);

Ytest = Y(idx_test);

Xtest = X(idx_test,:);

%% train usign ERM

PHItrain = [ones(ntrain,1) Xtrain];

[~, d] = size(PHItrain);

theta_tilda = zeros(d,1);

p = 1/ntrain.*ones(ntrain,1);

theta_hat = log_reg(p, PHItrain, Ytrain, theta_tilda);

%% train accuracy

train_acc = sum(Ytrain==(sig(PHItrain*theta_hat)> 0.5))/ntrain;

%% testing accuracy

ntest = length(Ytest);

PHItest = [ones(ntest,1) Xtest];

test_acc = sum(Ytest==(sig(PHItest*theta_hat)> 0.5))/ntest;

%% add outliers

Ncorr = 40;

z = PHItrain*theta_hat;

[z_sort, z_idx] = sort(z,'descend');

z_idx_corr = z_idx(1:Ncorr);

Ytrain_corr = Ytrain;

Ytrain_corr(z_idx_corr) = 0;

%%  train ERM with corrupted data

PHItrain = [ones(ntrain,1) Xtrain];

[~, d] = size(PHItrain);

theta_tilda = zeros(d,1);

p = 1/ntrain.*ones(ntrain,1);

theta_hat_corr = log_reg(p, PHItrain, Ytrain_corr, theta_tilda);

%% test accuracy with corrupted data

ntest = length(Ytest);

PHItest = [ones(ntest,1) Xtest];

test_acc_corr = sum(Ytest==(sig(PHItest*theta_hat_corr)> 0.5))/ntest;

%% robust logReg RRM

epsilon = 0.15;

theta_hat_rob = robust_logReg(PHItrain, Ytrain_corr, p , theta_tilda, epsilon);

%% test accuracy robust

ntest = length(Ytest);

PHItest = [ones(ntest,1) Xtest];

test_acc_corr_rob = sum(Ytest==(sig(PHItest*theta_hat_rob)> 0.5))/ntest;

%% robust SEVER

theta_hat_sev = sever_logReg(PHItrain,Ytrain_corr,theta_tilda,epsilon,4);

%%
ntest = length(Ytest);

PHItest = [ones(ntest,1) Xtest];

test_acc_corr_sev = sum(Ytest==(sig(PHItest*theta_hat_sev)> 0.5))/ntest;

%%
save('C:\Osama_Uppsala\Robust project\Data\logReg_cancer.mat')