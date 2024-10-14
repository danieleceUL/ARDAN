%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Date: 25/03/2023
%   Name: Daniel Jakab
%   Description: Execute SFR ROI Analysis for multiple directory outputs
%   University of Limerick
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function multi_exp_analysis_func(selpath)
    %expected CSV files
    fh = 'horizontal.csv';
    fv = 'vertical.csv';
    d = dir(selpath);
    isub = [d(:).isdir]; %# returns logical vector
    nameFolds = {d(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];
    i = 1; %number of subdirectories in selpath
    nextSubDir = selpath;
    %% check if CSV files exist in selected path
    tic
    disp('Processing...');
    if (isfile([selpath filesep fh]) && isfile([selpath filesep fv]))
        tt_n = 'tt_img';
        imFiles = [...
            dir(fullfile([selpath filesep [tt_n '.jpg']]));
            dir(fullfile([selpath filesep [tt_n '.jpeg']]));
            dir(fullfile([selpath filesep [tt_n '.png']]));
            dir(fullfile([selpath filesep [tt_n '.tif']]));
            dir(fullfile([selpath filesep [tt_n '.tiff']]));
            dir(fullfile([selpath filesep [tt_n '.dcg']]));
            dir(fullfile([selpath filesep [tt_n '.raw']]));
            ];
        tt_img = imread(fullfile(imFiles.folder, imFiles.name));
        dataH = readmatrix([selpath filesep fh]);
        dataV = readmatrix([selpath filesep fv]);
    
        nssfr_analysis(selpath, tt_img, dataH, dataV)
    else
        while  i < (size(nameFolds,1) + 1)
            if size(nameFolds,1) > 0 
                subdir = nameFolds(i, 1);
                disp(strcat('Entering subdirectory: ', subdir{1,1}))
                nextSubDir = [selpath filesep subdir{1,1}];
            else
                disp('No valid subdirectories...');
                break;
            end
            if (isfile([nextSubDir filesep fh]) && isfile([nextSubDir filesep fv]))
                tt_n = 'tt_img';
                imFiles = [...
                    dir(fullfile([nextSubDir filesep [tt_n '.jpg']]));
                    dir(fullfile([nextSubDir filesep [tt_n '.jpeg']]));
                    dir(fullfile([nextSubDir filesep [tt_n '.png']]));
                    dir(fullfile([nextSubDir filesep [tt_n '.tif']]));
                    dir(fullfile([nextSubDir filesep [tt_n '.tiff']]));
                    dir(fullfile([nextSubDir filesep [tt_n '.dcg']]));
                    dir(fullfile([nextSubDir filesep [tt_n '.raw']]));
                    ];
                tt_img = imread(fullfile(imFiles.folder, imFiles.name));
                dataH = readmatrix([nextSubDir filesep fh]);
                dataV = readmatrix([nextSubDir filesep fv]);
            
                nssfr_analysis(nextSubDir, tt_img, dataH, dataV)
            end
            nextSubDir = selpath;
            i = i + 1;
        end
    end
    toc
    disp('Completed System e-SFR Estimation');
end
