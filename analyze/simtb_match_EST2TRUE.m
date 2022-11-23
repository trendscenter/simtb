function [mIND, rIND, mSTRENGTH, Rvalues, RMAT] = simtb_match_EST2TRUE(SMest, SMtrue)
%   simtb_match_EST2TRUE()  - Matches estimated to true SMs based on maximum R^2 statistics
%
%   Usage:
%    >> [mIND, rIND, mSTRENGTH, Rvalues, RMAT] = simtb_match_EST2TRUE(SMest, SMtrue)
%
%   INPUTS:
%   SMest   = [nEC x nVV] estimated SMs, where nEC is the number of 
%                           estimated components and nVV is the number
%                           of voxels to analyze (may be masked data).
%   SMtrue  = [nC x  nVV] true SMs (saved in *_DATA.mat), 
%                           where nC is the true number of sources.
%   
%   NOTE:   SMest and SMtrue can be the mean (or aggregate) SMs across the group 
%           or the SMs for a single subject.  The number of estimated components (nEC)
%           may be greater or less than the number of true sources (nC).
%
%   OUTPUTS:
%   mIND      = indices that best map SMtrue to SMest, i.e., SMest ~ SMtrue(mIND,:);
%   rIND      = indices that best map SMest to SMtrue, i.e., SMtrue ~ SMest(rIND,:);
%   mSTRENGTH = strength of the match, defined as mSTRENGTH = (M1-M2)/(M1+M2), where
%               M1 is the maximum absolute beta coefficient, and M2 is the second greatest. 
%               Betas are determined from the multiple linear regression where true components 
%               are the predictors and the estimated component is the observation.
%               mSTRENGTH ranges from [0,1], 0 indicating a poor match, 1 indicating a good match.
%   Rvalues   = R^2-statistics between the estimated and true components
%   RMAT      = Full R2-statistic matrix, size [nEC x nC].  
%
%  see also: simtb_regression()


[nEC, nVV] = size(SMest);
[nC, nVV] = size(SMtrue);

%% Match components based on the maximum R2
RMAT = corr(SMest', SMtrue').^2;
[Rvalues, mIND]  = max(RMAT,[],2);
[Rvalues2, rIND] = max(RMAT, [], 1);

%% Now use truth as the design matrix to determine the match strength
TMAT = zeros(nEC,nC);
BMAT = zeros(nEC,nC);

for c = 1:nEC
    thiscomponent = SMest(c,:)';
    % Compute T-statistics, Beta coefficients
    [Ts, Betas] = simtb_regression([ones(nVV,1) , SMtrue'], thiscomponent);
    BMAT(c,:) = abs(Betas(2:end)); %first term is the intercept   
    TMAT(c,:) = abs(Ts(2:end));    %first term is the intercept   
end
%% strength of the match based on the difference between ranked Beta coefficients
sortedBs = sort(BMAT,2, 'descend');
mSTRENGTH = (sortedBs(:,1)-sortedBs(:,2))./(sortedBs(:,1)+sortedBs(:,2));




