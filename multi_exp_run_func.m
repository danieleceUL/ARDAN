%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Date: 27/10/2023
%   Name: Daniel Jakab
%   Description: Execute SFR ROI Proposal for multiple experiments
%
%   Maximum Hierarchy structure accepted:
%   Level 0/
%       Level 1/
%           Level 2/
%               Level 3/
%                   Level 4/
%                       Level 5/
%                           *.png/jpg/jpeg/tif/tiff/dcg/raw
%   With one Subdirectory acting as a multi-environment.
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
    esfW = 5; %5,10
    
    % define the min and max edge length in pixels
    minEdge = 20; %minimum length of an edge
    maxEdge = 128;%maximum length of an edge
    
    % define edge contrast
    Con=[0.1, 0.9];
    
    % set raw flag to zero for now
    raw = 0;
    % set polynomial fit for MTF
    npoly=5;
    
    % set limit on energy above 0.5 cy/px
    hfMax = 0.2;
    
    %use data convexity check
    dcheck = 1;
    
    sfrv = 'sfrmat5';
    
    d = dir(selpath)
    isub = [d(:).isdir]; %# returns logical vector
    nameFolds = {d(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];

    mskpath = './masks/';
    
    tic
    t = {'.png', '.jpg', '.jpeg',...
        '.png', '.tif', '.tiff',...
        '.dcg', '.raw'};
    i = 1; % subsub+ directory iteration
    j = 1; % parent directory iteration
    k = 1; % sub directory iteration
    l = 0; %level of directory
    
    PNameFolds = nameFolds;
    nextSubDir = selpath;
    subNameFolds = [];
    subRefDir = {};
    if size(PNameFolds, 1) ~= 0 
        %Iterate through the entire hierarchy to find the files.
        while i < (size(PNameFolds, 1) + 1)
            if size(nameFolds, 1) ~= 0
                if isequal(PNameFolds,nameFolds)
                    subRefDir = {};
                    nextSubDir = selpath;
                    if k > 1
                        k = 1; % set back k to 1
                        l = 0;
                        j = j + 1; % increment parent directory counter
                    end
                    if j <= size(nameFolds,1)
                        subdir = nameFolds(j, 1);
                    else
                        break;
                    end
                elseif ~isempty(subNameFolds)
                    subdir = subNameFolds(k, 1);
                    subNameFolds = [];
                else
                    subdir = nameFolds(i, 1);
                end
                path = [nextSubDir filesep subdir{1,1}];
            else
                path = nextSubDir;
            end
            
            ifn = ~[d(:).isdir]; %# returns logical vector if file exists
            fname = {d(ifn).name}';
            fname(ismember(fname,{'.','..'})) = [];
            if size(fname, 1) ~=0
                isImage = find(cellfun(@(s) contains(fname{1,1},s),t), 1);
            else
                isImage = 0;
            end
            if isImage
                target=regexp(nextSubDir,filesep,'split');
                subdirN = target(end-l+1:end);
                mark = {'..'};
                relPathCheck = find(cellfun(@(s) contains(mark,s),subdirN), 1);
                if relPathCheck
                    subdirN(relPathCheck) = []; %remove change directory mark
                    subdirN(relPathCheck-1) = []; %remove the directory just before it
                    subdirN = [target(end-(l+2)+1) target(end-(l+1)+1) subdirN] %add in the subdirectory names below
                end
                subdirN(2,:) = {'_'};
                name = [subdirN{:}]; % create custom name for each run based on subdirectories
                nssfr_exp(nextSubDir, name, selmsk, mskpath, resultdir, numWorkers, debug, valInval, ST, esfW, ...
                    minEdge, maxEdge, Con, raw, npoly, hfMax, dcheck, sfrv)
                disp(['File List: ' num2str(size(fname, 1))])
                i=i+1;
                nextSubDir = [nextSubDir filesep '..'];
                l = l - 1; %reduce level
                d = dir(nextSubDir);
                isub = [d(:).isdir]; %# returns logical vector
                nameFolds = {d(isub).name}';
                nameFolds(ismember(nameFolds,{'.','..'})) = [];
                if ~(i < size(nameFolds, 1) + 1)
                    i = 1; %set i back to 1
                    nextSubDir = [nextSubDir filesep '..'];
                    l = l - 1; %reduce level
                    d = dir(nextSubDir);
                    isub = [d(:).isdir]; %# returns logical vector
                    nameFolds = {d(isub).name}';
                    nameFolds(ismember(nameFolds,{'.','..'})) = [];
                    while size(nameFolds, 1) == 1
                        nextSubDir = [nextSubDir filesep '..'];
                        l = l - 1; %reduce level
                        d = dir(nextSubDir);
                        isub = [d(:).isdir]; %# returns logical vector
                        nameFolds = {d(isub).name}';
                        nameFolds(ismember(nameFolds,{'.','..'})) = [];
                    end
                    %if negative number for level then end the task.
                    if l < 0
                        break;
                    end
                    if k < size(nameFolds, 1)
                        subNameFolds = nameFolds;
                        nextSubDir = subRefDir{l,1};
                        subRefDir = {};
                        k = k + 1;
                    else
                        subNameFolds = [];
                        nextSubDir = [nextSubDir filesep '..'];
                        d = dir(nextSubDir);
                        isub = [d(:).isdir]; %# returns logical vector
                        nameFolds = {d(isub).name}';
                        nameFolds(ismember(nameFolds,{'.','..'})) = [];
                        while size(nameFolds, 1) == 1 || ~isequal(nameFolds, PNameFolds)
                            nextSubDir = [nextSubDir filesep '..'];
                            l = l - 1; %reduce level
                            d = dir(nextSubDir);
                            isub = [d(:).isdir]; %# returns logical vector
                            nameFolds = {d(isub).name}';
                            nameFolds(ismember(nameFolds,{'.','..'})) = [];
                        end
                    end
                    
                end
            else
                d = dir([nextSubDir filesep subdir{1,1}])
                isub = [d(:).isdir]; %# returns logical vector
                nameFolds = {d(isub).name}';
                nameFolds(ismember(nameFolds,{'.','..'})) = [];
                if ~isequal(nextSubDir, selpath)
                    subRefDir = [subRefDir; nextSubDir];
                end
                nextSubDir = [nextSubDir filesep subdir{1,1}];
                l = l + 1;
                if l > 5
                    disp('Hierarchy too large. Level number should be a maximum of 5')
                    exit();
                end
            end
        end
    else
        %Files should be on first level of the hierarchy
        ifn = ~[d(:).isdir]; %# returns logical vector if file exists
        fname = {d(ifn).name}';
        fname(ismember(fname,{'.','..'})) = [];
        isImage = find(cellfun(@(s) contains(fname{1,1},s),t), 1);
        splitSrc = split(selpath, filesep);
        name = splitSrc(end);
        if isImage
            nssfr_exp(nextSubDir, name, selmsk, mskpath, resultdir, numWorkers, debug, valInval, ST, esfW, ...
                        minEdge, maxEdge, Con, raw, npoly, hfMax, dcheck, sfrv)
            disp(['File List: ' num2str(size(fname, 1))])
        end
    end
    toc
    disp('Completed NS-SFR Extraction for multiple/single dataset(s)');
end