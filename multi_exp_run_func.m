%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Date: 26/07/2024
%   Name: Daniel Jakab
%   Description: Execute SFR ROI Proposal for multiple experiments
%
%   Maximum Hierarchy structure accepted:
%   Level 0/
%       Level 1/
%            *.png/jpg/jpeg/tif/tiff/dcg/raw
%   With one Subdirectory acting as a multi-environment.
%   Copyright (c) 2024 D. Jakab
%   UNIVERSITY OF Limerick PhD Research
%              - D2ICE Research Group
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function multi_exp_run_func(selpath, resultdir, selmsk)
    numWorkers = 4;
    debug = 1;
    valInval = 0;
    set(0, 'DefaultFigureVisible', 'off');
    %% configure detection parameters
    ST   = 0.02;%0.02, 0.04
    % ESF min width for system (pixels) - Change this threshold based on
    % a modeled MTF - pixels for no overlapping ESFs
    esfW = 10; %5,10 % set to 10 for more reliable esf extraction
    
    % define the min and max edge length in pixels
    minEdge = 20; %minimum length of an edge
    maxEdge = 80;%maximum length of an edge (set to 100 for more vertical MTF measurements)
                %Woodscape set to 80 to avoid long edges from trees (distortion tends to reduce data)
    
    % define edge contrast
    Con=[0.1, 0.9]; % [min, max] contrast for edge selection
    
    % set raw flag to zero for now
    raw = 0;
    % set polynomial fit for MTF
    npoly=5;
    
    % set limit on energy above 0.5 cy/px
    hfMax = 0.1; %set a lower limit of 0.2 cy/px for hf energy
    
    %use data convexity check
    dcheck = 1;
    
    sfrv = 'sfrmat5';
    tic
    
    subdirs = dir(selpath);

    for j = 1:length(subdirs)
        if subdirs(j).isdir && ~strcmp(subdirs(j).name, '.') && ~strcmp(subdirs(j).name, '..')
            iterateDirectory(selpath, subdirs(j), resultdir, selmsk, numWorkers, ...
                            debug, valInval, ST, esfW, Con, raw, npoly, minEdge, maxEdge, hfMax, dcheck, sfrv)
        end
    end
    toc
    disp('Completed NS-SFR Extraction for multiple/single dataset(s)');
    clear all;
    close all;
    clc
end

function iterateDirectory(selpath, folderPath, resultdir, selmsk, numWorkers, ...
                    debug, valInval, ST, esfW, Con, raw, npoly, minEdge, maxEdge, hfMax, dcheck, sfrv)
    % Get the list of all files and folders in the directory
    mskpath = './masks/';
    disp(folderPath)
    subDirPath = [selpath filesep folderPath.name] 
    items = dir(subDirPath);
    disp(items)
    
    t = {'.png', '.jpg', '.jpeg',...
    '.png', '.tif', '.tiff',...
    '.dcg', '.raw'};

    % Loop through each item
    if ~items(3).isdir
        %Files should be on this level of the hierarchy
        ifn = ~[items(:).isdir]; %# returns logical vector if file exists
        fname = {items(ifn).name}';
        fname(ismember(fname,{'.','..'})) = [];
        isImage = find(cellfun(@(s) contains(fname{1,1},s),t), 1);
        name = items.name;
        if isImage
            nssfr_exp(subDirPath, folderPath.name, selmsk, mskpath, resultdir, numWorkers, debug, valInval, ST, esfW, ...
                        minEdge, maxEdge, Con, raw, npoly, hfMax, dcheck, sfrv)
            disp(['File List: ' num2str(size(fname, 1))])
        end
    end
end
