# robustRisk
Code for experiments in the paper, "Robust Risk Minimization for Statistical Learning", Muhammad Osama, Dave Zachariah, Peter Stoica. https://ieeexplore.ieee.org/abstract/document/9265228

This readme file provides a summary of which scripts/codes is related to which  experiements in the paper so that it is easy for the reader to navigate. 
************************************************
The folder function contains all the supporting functions
 needed to run the scripts below. 
************************************************

*********************
1) Montecarlo_linReg.m
This scripts computes relative error for the proposed robust method and compares it against relative errors for the SEVER, Huber and ERM for the linear regression setting. The numerical settings are as described in the paper in section 4.1 (figure 3a) 

*********************
2) mse_vs_eps.m
This script computes the relative error with respect to the percentage of corrupted data (eps) over 2000 Montecarlo runs. The experimental settings are as described in section 4.1 (figure 3b). It takes a lot of time to run since we are doing 2000 runs for each of the 30 different eps values. Reduce the # of monte carlo runs to reduce time. 

**********************
3) Montecarlo_logReg.m
This script is related to section 4.2 (figure 4) of paper on logistic regression. 

**********************
4) Montecarlo_pca.m
This script is related to section 4.3 on prinicipal component analysis (figure 5).

**********************
5) Montecarlo_CovEst.m
This script is related to section 4.4 on covariance estimation of paper

**********************
6) logReg_canver.m
This script is related to section 5 of paper on real data in which Wisconsin cancer data from UCI repository is considered. The data is also attached with the code. 
