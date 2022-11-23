function [t, beta] = simtb_regression(X,y)
%   simtb_regression()  - Performs least squares multiple linear regression
%
%   Usage:
%    >> [t, beta] = simtb_regression(X,y)
%
%   INPUTS: 
%   X          = [mobservations x nregressors] design matrix
%   y          = [mobservations x 1] vector of observations
%
%   OUTPUTS:
%   t          = [nregressors x 1] vector of t-statistics for regressors
%   beta       = [nregressors x 1] vector of beta coefficients for regressors
%
%   see also: simtb_match_EST2TRUE()

[Q,R]=qr(X,0);
beta = R\(Q'*y);
yhat = X*beta;
residuals = y - yhat;
nobs = length(y);
p = length(beta);
dfe = nobs-p;
%  dft = nobs-1;
%  ybar = mean(y);
sse = norm(residuals)^2;       % sum of squared errors
%  ssr = norm(yhat - ybar)^2;  % regression sum of squares
%  sst = norm(y - ybar)^2;     % total sum of squares;
mse = sse./dfe;
%  h = sum(abs(Q).^2,2);
%  s_sqr_i = (dfe*mse - abs(residuals).^2./(1-h))./(dfe-1);
%  e_i = residuals./sqrt(s_sqr_i.*(1-h));
ri = R\eye(p);
xtxi = ri*ri';
covb = xtxi*mse;
se = sqrt(diag(covb));
t = beta./se;