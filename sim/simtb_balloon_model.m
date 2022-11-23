function tc = simtb_balloon_model(eTC, TR, P)
% simtb_balloon_model()  - Nonlinear balloon model to generate TCs
%
% Usage:
%  >> [tc] = simtb_balloon_model(eTC, P, x);
%
% INPUTS:
% eTC          = [nT x 1] event vector
% TR           = repetition time (in seconds)
% P (OPTIONAL) = vector of parameters for the BOLD generation model 
%
% OUTPUTS:
% tc   =  [nT x 1] component time course
%
% see also: simtb_TCsource()
% -----------------------------------------------------------------
% SEE:
% Friston, A Mechelli, R Turner, CJ Price, 2000. Nonlinear responses in fMRI:
% the Balloon model, Volterra kernels, and other hemodynamics. Neuroimage.
%
% Buxton, R.B. and Wong, E.C. and Frank, L.R. 1998. Dynamics of blood flow
% and oxygenation changes during brain activation: the balloon model. Magnetic Resonance in Medicine.
% -----------------------------------------------------------------
% hemodynamic model
%
% INPUTS:
%   eTC    - input (neuronal activity)                    (eTC)
%   P      - free parameter vector
%   P(1) - signal decay                                   d(ds/TR)/ds)
%   P(2) - autoregulation                                 d(ds/TR)/df)
%   P(3) - transit time                                   (t0)
%   P(4) - exponent for Fout(v)                           (alpha)
%   P(5) - resting oxygen extraction                      (E0)
%   P(6) - echo time   (seconds)                          (TE)
%   P(7) - input efficacies                               d(ds/TR)/du)
%
%   TR - repeat time (sec)                                (TR)
%
% OUTPUTS:
% tc      - output BOLD signal


nT = length(eTC);

% parameters must be a column vector
P = P(:); 
%   x      - state vector
%   x(1) - vascular signal                                    s
%   x(2) - rCBF                                           log(f)
%   x(3) - venous volume                                  log(v)
%   x(4) - dHb                                            log(q)
% x0, Initialization of states; leave this alone
x = [0; 0; 0; 0];

% ------------------------------------------------------------------------
% hemodynamic forward model (state equations)
% ------------------------------------------------------------------------
% First, solve the differential equations for all the states

dTR = 0.1; %seconds; need a small step size to solve the equations
           % step of integration of the model
           
dtsize = dTR/TR; % fractional bin size

k  = 1;
for t = 2:(nT/dtsize)
    if mod(t,1/dtsize) == 0 && t~= nT/dtsize
        k = k+1;
        U = eTC(k);
    else
        U = 0;
    end
    f = feval(@hdm_fx,x(:,t-1),U,P);
    dfdx = spm_diff(@hdm_fx,x(:,t-1),U,P,1);
    x(:,t) = x(:,t-1) + spm_dx(dfdx,f,dTR);
end

% Estimate BOLD given the state vector
tc = hdm_gx(x,P);

% Downsample
tc = interp1(tc, 1:1/dtsize:nT/dtsize)';


%-----------------------------------
%SUB-FUNCTIONS

function [f] = hdm_fx(x,eTC,P)
% hemodynamic forward model
%
%   x      - state vector
%   x(1) - vascular signal (coupling between neural activity and blood flow)      s
%   x(2) - rCBF   (cerebral blood flow)                                           log(f)
%   x(3) - venous volume  (cerebral venous blood volume)                          log(v)
%   x(4) - dHb   (deoxyhemoglobin fraction)                                       log(q)
%   eTC      - input (neuronal activity)                                          (eTC)
%   P      - free parameter vector
%   P(1) - signal decay                                   d(ds/TR)/ds)
%   P(2) - autoregulation                                 d(ds/TR)/df)
%   P(3) - transit time                                   (t0)
%   P(4) - exponent for Fout(v)                           (alpha)
%   P(5) - resting oxygen extraction                      (E0)
%
%   P(7) - input efficacies                       d(ds/TR)/du)

% Fout = f(v) - outflow
%--------------------------------------------------------------------------
x(2:4,:)    = exp(x(2:4,:));
fv(:,:)       = x(3,:).^(1./P(4,:));

% e = f(f) - oxygen extraction
%--------------------------------------------------------------------------
ff(:,:)       = (1 - (1 - P(5,:)).^(1./x(2,:)))./P(5,:);

% implement differential state equations
%--------------------------------------------------------------------------
f(1,:)     = P(7,:).*eTC(:,:) - P(1,:).*x(1,:) - P(2,:).*(x(2,:) - 1);
f(2,:)     = x(1,:)./x(2,:);
f(3,:)     = (x(2,:) - fv)./(P(3,:).*x(3,:));
f(4,:)     = (ff.*x(2,:) - fv.*x(4,:)./x(3,:))./(P(3,:).*x(4,:));




function y = hdm_gx(x,P)
%-------------------------------------------------------------------------
% measurement equations:
%-------------------------------------------------------------------------

% resting venous volume
%--------------------------------------------------------------------------
V0    = 100*0.08;
% slope r0 of intravascular relaxation rate R_iv as a function of oxygen
% saturation Y:  R_iv = r0*[(1-Y)-(1-Y0)]
%--------------------------------------------------------------------------
r0    = 25;
% frequency offset at the outer surface of magnetized vessels
%--------------------------------------------------------------------------
nu0   = 40.3;
% region-specific resting oxygen extraction fractions
%--------------------------------------------------------------------------
E0    = P(5,:);
% region-specific ratios of intra- to extravascular components of
% the gradient echo signal (prior mean = 1, log-normally distributed
% scaling factor)
%--------------------------------------------------------------------------
epsi  = exp(0.02);
% ratio of intra- to extravascular components of
% the gradient echo signal
% -------------------------------------------------------------------------
TE    = P(6,:);
% coefficients in BOLD signal model
%--------------------------------------------------------------------------
k1    = 4.3.*nu0.*E0.*TE;
k2    = epsi.*r0.*E0.*TE;
k3    = 1 - epsi;

x = exp(x);
% BOLD signal generation
%--------------------------------------------------------------------------
v     = x(3,:);
q     = x(4,:);
y     = V0.*(k1.*(1 - q) + k2.*(1 - (q./v)) + k3.*(1 - v));