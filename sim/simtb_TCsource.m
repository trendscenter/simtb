function [tc, MDESC, P, PDESC] = simtb_TCsource(eTC, TR, sourceType, P)
% simtb_TCsource()  - Contains the definitions for the generation of TCs
%
% Usage:
%  >> [tc, MDESC, P, PDESC] = simtb_TCsource(eTC, TR, sourceType);
%  >> [tc, MDESC, P, PDESC] = simtb_TCsource(eTC, TR, sourceType, P);
%
% INPUTS:
% eTC          = [nT x 1] event vector
% TR           = repetition time (in seconds)
% sourceType   = model to use for the generation of the TC
% P            = vector of parameters for the BOLD generation model [OPTIONAL]
%
% OUTPUTS:
% tc      =  [nT x 1] component time course
% MDESC   =  Description of the model used
% P       =  Parameters used in model
% PDESC   =  Description of model parameters
%
% see also: simtb_countTCmodels()

if nargin < 4 || isempty(P)
    % use the default parameters for this model
    P = get_default_params(sourceType);
else
    % verify the correct number of paramters for this model
    [count, MDESC, NPARAMS, PDESC] = simtb_countTCmodels;
    if length(P) ~= NPARAMS(sourceType);
        errstring = sprintf('TC model %d requires %d parameters.  You entered %d',...
            sourceType, NPARAMS(sourceType), length(P));
        error(errstring)
        disp(PDESC{sourceType});
    end
end

eTC = eTC(:);
nT = length(eTC);

if sourceType == 1
    MDESC = 'Convolution with canonical HRF (difference of two gamma functions)';
    PDESC = sprintf([...
        '\tP(1): delay of response (relative to onset)\n',...
        '\tP(2): delay of undershoot (relative to onset)\n',...
        '\tP(3): dispersion of response\n',...
        '\tP(4): dispersion of undershoot\n',...
        '\tP(5): ratio of response to undershoot\n',...
        '\tP(6): onset (seconds)\n',...
        '\tP(7): length of kernel (seconds)']);
    hrf = simtb_spm_hrf(TR, P);
    atemp = conv(hrf, eTC);
    tc = atemp(1:nT);

elseif sourceType == 2
    MDESC = 'Windkessel Balloon Model, see Friston et al., Neuroimage (2000)';
    PDESC = sprintf([...
        '\tP(1): 1/(signal decay)                              (1/Ts)\n',...
        '\tP(2): 1/(autoregulation)                            (1/Tf)\n',...
        '\tP(3): transit time                                  (t0)\n',...
        '\tP(4): stiffness                                     (alpha)\n',...
        '\tP(5): resting oxygen extraction fraction            (E0)\n',...
        '\tP(6): echo time (seconds)                           (TE)\n',...
        '\tP(7): neural efficacy                               (epsilon)']);
    tc = simtb_balloon_model(eTC, TR, P);

elseif sourceType == 3
    MDESC = 'Convolution with fast spike (difference of two gamma functions)';
    PDESC = sprintf([...
        '\tP(1): delay of response (relative to onset)\n',...
        '\tP(2): delay of undershoot (relative to onset)\n',...
        '\tP(3): dispersion of response\n',...
        '\tP(4): dispersion of undershoot\n',...
        '\tP(5): ratio of response to undershoot\n',...
        '\tP(6): onset (seconds)\n',...
        '\tP(7): length of kernel (seconds)']);
    spike = simtb_spm_hrf(TR, P);
    atemp = conv(spike, eTC);
    tc = atemp(1:nT); 
else
    %% Important 'else' condition for determining number of defined models.  Do not remove.
    tc = [];
    MDESC = [];
    P = [];
    PDESC = [];
end

% --------------------------------------------------------
%                    SUB-FUNCTIONS
% --------------------------------------------------------
function  P = get_default_params(sourceType)
if sourceType == 1
    %% 'Convolution with canonical HRF';
    % HRF parameters vary slightly between components/subjects
    % P: 1x7 vector of parameters for the response kernel (difference of two gamma functions)
    P(1) = 4+3*abs(randn(1));     % delay of response (relative to onset)
    P(2) = 12+3*abs(randn(1));    % delay of undershoot (relative to onset)
    P(3) = 1+0.2*randn(1);        % dispersion of response
    P(4) = 1+0.2*randn(1);        % dispersion of undershoot
    P(5) = 2+3*abs(randn(1));     % ratio of response to undershoot
    P(6) = 0;                     % onset (seconds)
    P(7) = 32;                    % length of kernel (seconds)

elseif sourceType == 2
    %% 'Hemodynamic nonlinear model (Windkessel Balloon Model)';
    % model parameters vary slightly between subjects/components.
    % P: 1x7 vector of parameters; see Figure 7 of Friston et al., 2000.
    P(1) = 1/(1.54+0.15*randn(1));           % signal decay
    P(2) = 1/(2.46+0.15*randn(1));           % autoregulation
    %P(3) = 2+0.15*randn(1);                  % transit time
    P(3) = 0.98 + 0.15*randn(1);                  % transit time
    P(4) = 0.36;                             % stiffness
    P(5) = 0.34;                             % OEF
    P(6) = 0.04;                             % TE
    P(7) = 0.54;                             % neural efficacy
elseif sourceType == 3
    %% 'Convolution with fast spike';
    % 'Spike' parameters vary slightly between components/subjects
    % P: 1x7 vector of parameters for the response kernel (difference of two gamma functions)
    P(1) = 2+.05*randn(1);        % delay of response (relative to onset)
    P(2) = 6+0.05*randn(1);       % delay of undershoot (relative to onset)
    P(3) = 0.8+0.02*randn(1);     % dispersion of response
    P(4) = 1+0.02*randn(1);       % dispersion of undershoot
    P(5) = 4;                     % ratio of response to undershoot
    P(6) = 0;                     % onset (seconds)
    P(7) = 20;                    % length of kernel (seconds)
else
    P = [];
end