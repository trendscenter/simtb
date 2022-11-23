function simtb_main(sP)
% simtb_main()  - Main function for performing simulations
%           For each subject:
%           - Generates time courses (TC) and spatial maps (SM)
%           - Multiplies TC*SM and adds scaled activations to baseline (B) to make dataset (D)
%           - Simulates dataset motion (OPTIONAL)
%           - Adds Rician noise to dataset (OPTIONAL)
%           - Saves parameters, TC, SM, dataset, motions parameters and any figures displayed.
%
% Usage:
%  >> simtb_main(sP)
%
% INPUTS:
% sP        = simulation parameter structure 
%
% OUTPUTS:
% (none, all outputs are saved to file).
% If sP.verbose_display, will display and save images of parameters and output
%
% see also: simtb_create_sP(), simtb_params()

fprintf('--------------------------------------------------------------------\n')
fprintf('---------------------Initializing Simulation------------------------\n')
fprintf('--------------------------------------------------------------------\n')
fprintf('\n')

%% Verify that the paramters are reasonable and consistent with themselves
[errorflag, Message] = simtb_checkparams(sP);

if errorflag
    fprintf('Please check your simulation parameters:\n')
    fprintf(['\t' Message(end,:) '\n']);
    return
else
    vd = {'OFF', 'ON'};
    fprintf('Output directory: %s\n', sP.out_path)
    fprintf('     File prefix: %s\n', sP.prefix)
    fprintf(' Verbose display: %s\n', vd{sP.verbose_display+1});
    fprintf('\n')
end


if sP.verbose_display
    model_figure = simtb_figure_model(sP);
    saveas(model_figure, simtb_makefilename(sP, 'model figure'), 'fig')
    saveas(model_figure, simtb_makefilename(sP, 'model figure'), 'jpg')
    param_figures = simtb_figure_params(sP);
    for ii = 1:length(param_figures)
        saveas(param_figures(ii), simtb_makefilename(sP, get(param_figures(ii), 'name')), 'fig')
        saveas(param_figures(ii), simtb_makefilename(sP, get(param_figures(ii), 'name')), 'jpg')
    end
end

% set the states of the random number generators
simtb_rand_seed(sP.seed);


%% for convenience
M     = sP.M;     % number of subjects
nC    = sP.nC;    % number of components
nV    = sP.nV;    % number of 1-D voxels
nT    = sP.nT;    % number of time points
D_pSC = sP.D_pSC; % percent signal change of activation

% initialize vector for keeping track of time
t = zeros(1,M);
% initialize matrix for scaled SMs
scaledSM = zeros(nC, nV*nV);

%--------------------------------------------------------------------------
% Beginning of simulation for subject 
%--------------------------------------------------------------------------
for sub = 1:M
    tic
    fprintf('\tSubject %d of %d:\n', sub, M)

    %% Build the time courses
     fprintf('\t\tBuilding Time Courses\n')
    [TC, eTC, blocks, events, uevents, sP] = simtb_makeTC(sP, sub);
    % TC is [nT x nC] (time points x components)

    %% Generate the spatial maps
    fprintf('\t\tBuilding Spatial Maps\n')
    SM = simtb_makeSM(sP, sub);
    % SM is [nC x nV*nV]

    %% Make the baseline intensity matrix for each subject
    B = simtb_makeBaseline(sP, sub);
    B = reshape(B,1,nV*nV);

    %% Scale the SMs appropriately given the baseline and percent signal change
    for c=1:nC
        scaledSM(c,:) = (D_pSC(sub,c)/100)*SM(c,:).*B;
    end

    %% multiply the TC x scaled SM and add to baseline
    fprintf('\t\tBuilding Dataset\n')
    D = TC*scaledSM + repmat(B,nT,1);

    %% Determine Rician noise level (before adding motion)
    if sP.D_noise_FLAG
        mask = simtb_createmask(sP);
        mask = find(mask == 1);
        signal_std = trimmean(std(D(:,mask)), 30);
        noise_std = signal_std/sP.D_CNR(sub);
    end

    %% add motion to the dataset
    if sP.D_motion_FLAG        
        fprintf('\t\tAdding Motion\n')
        [D, sP, mp] = simtb_addMotion(sP, D, sub); 
        % Note that sP.DnV will be updated here to include padding

        % save the motion parameters to a text file
        fprintf('\t\tSaving Motion Parameters\n')
        simtb_saveMOT(mp, simtb_makefilename(sP, 'MOT', sub));

        if sP.verbose_display
            motion_figure = simtb_show_motion(sP, sub);
            saveas(motion_figure, simtb_makefilename(sP, get(motion_figure, 'name')), 'fig');
            saveas(motion_figure, simtb_makefilename(sP, get(motion_figure, 'name')), 'jpg');
            close(motion_figure) % Close these to avoid large number of figures
        end
    else
        sP.DnV = nV;
    end

    
    %% add Rician noise
    if sP.D_noise_FLAG
        fprintf('\t\tAdding Noise\n')
        noise1 = noise_std*randn(size(D));
        noise2 = noise_std*randn(size(D));
        D = sqrt((D + noise1).^2 + (noise2).^2);
        clear noise1 noise2 B;
    end

    %% Plot the correlation and TC/SM figure and save
    [cmTC, cmSM, comp_figure] = simtb_figure_output(sP, sub, TC, SM, sP.verbose_display);
    if sP.verbose_display
        saveas(comp_figure, simtb_makefilename(sP, 'output figure', sub), 'jpg')
        saveas(comp_figure, simtb_makefilename(sP, 'output figure', sub), 'fig')
        close(comp_figure) % Close these to avoid large number of figures
    end

    %% save the simulation results
    fprintf('\t\tSaving Simulated Components\n')
    save(simtb_makefilename(sP, 'SIM', sub), 'SM', 'TC', 'cmTC', 'cmSM');

    %% save data in .mat or nifti format
    fprintf('\t\tSaving Simulated Dataset\n') 
    if sP.saveNII_FLAG
        D = reshape(D, nT,sP.DnV,sP.DnV);
        D = shiftdim(D,-1);
        D = permute(D,[3 4 1 2]);
        simtb_saveasnii(D, simtb_makefilename(sP, 'DATA', sub));
    else
        save(simtb_makefilename(sP, 'DATA', sub), 'D');
    end

    t(sub) = toc;
    fprintf('\tComplete.\n') 
    fprintf('\tTime to simulate subject %d: %0.1f s\n\n',  sub, t(sub))

    %% clear used variables
    clear TC SM D;
end
%--------------------------------------------------------------------------
% End of simulation for subject 
%--------------------------------------------------------------------------
%% save the complete parameter structure 
fprintf('Saving Parameter Structure\n') 
save(simtb_makefilename(sP, 'PARAMS'), 'sP');

fprintf('--------------------------------------------------------------------\n')
fprintf('------- Simulation Complete. Total Time: %0.1f minutes--------------\n', sum(t)/60)
fprintf('--------------------------------------------------------------------\n\n')

