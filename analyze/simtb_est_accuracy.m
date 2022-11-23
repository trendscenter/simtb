function A = simtb_est_accuracy(est, true)
%   simtb_est_accuracy()  - Determines the accuracy of the estimated features
%  
%   Usage:
%    >> A = simtb_est_accuracy(est, true)
%  
%   INPUTS: 
%   est          = [mobservations x nC] matrix of estimated features (TCs or SMs)
%   true         = [mobservations x nC] matrix of true features
%
%   NOTE:        Columns of est and true features should correspond, that is,
%                they should be in the same order.
%   OUTPUTS:
%   A          = [nC x 1] vector of accuracies (R^2 statistics)
%                between each estimated and true features                   
%
%  see also: simtb_match_EST2TRUE

%% R2 statistic (coefficient of determination)
R2 = diag(corr(est,true)).^2;

A = R2;