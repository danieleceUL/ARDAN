clear variables
close all
clc

% debug hardcode
set(0, 'DefaultFigureVisible', 'off');
%% select input file to read
selpath = uigetdir([], 'Select folder containing CSV files');
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
dataH = readmatrix([selpath filesep 'horizontal.csv']);
dataV = readmatrix([selpath filesep 'vertical.csv']);
tic
disp('Processing...');

%check if extra column exists for both MTF10 and MTF50 columns
%if MTF10 exists take consecutive columns
if (size(dataH, 2) == 115) && (size(dataV, 2) == 115)
    MTF_start = 15;
    MTF50 = 14;
    MTF10 = 13;
else
    MTF_start = 14;
    MTF50 = 13;
end

MTFdataH = dataH(:,MTF_start:end); %sfrmat4/5 measurements start at column 14
MTFdataV = dataV(:,MTF_start:end); %sfrmat4/5 measurements start at column 14
MTF50dataH = dataH(:,MTF50); % DJ - sfrmat4/5 MTF50 at column 13.
MTF50dataV = dataV(:,MTF50);

%H_locations = dataH(:,4:5);
%V_locations = dataV(:,4:5);
fList = [];

%% plot mean of all MTF plots
uq=(0:0.01:1.00)';
figure('Name', 'mean_MTFs');
hold on
title('Mean of all MTFs')
plot(uq,mean(MTFdataH));
plot(uq,mean(MTFdataV));
xlabel('cy/px')
legend('Horizontal','Vertical', 'FontSize', 5)
xlim([0 1])


%% plot MTF results by ROI

% define grid shape
nx = 8; %8
ny = 5; %5



cols = size(tt_img, 2);
rows = size(tt_img, 1);

numMTFsH = gpuArray(1:size(dataH, 1));
numMTFsV = gpuArray(1:size(dataV, 1));

% make a struct to match the MTF data to a grid location
MTFidxH = zeros(1,size(dataH,1));
MTFidxV = zeros(1,size(dataV,1));

RDseg = 4; % number of radial segments to split up domain
%ROImask = imageDatastore([selpath filesep 'ROIMask.jpg']);
%numWorkers = 4;

%ROImask = imread([selpath filesep 'ROIMask.png']);
roi = load([selpath filesep 'roi.mat']);
if isempty(tt_img)
    tt_img = ROImask;
end

%[Rad, RD] = RadAnnuli(MTF_Results{1, 2} , RDseg); % DJ replace with own tailored RadDist/annuli
[Rad, RD] = RadAnnuli_custom(RDseg, roi, tt_img);

%divide spatial domain up into grid segments
rec_x = size(tt_img,2)/nx;
rec_y = size(tt_img,1)/ny;
%[X,Y] = meshgrid(1:1:8, 1:1:5);

rad_gray = mat2gray(RD);

t = unique(rad_gray);
s = size(rad_gray);

%initialize mean distribution for spatial regions
MTFc = zeros(size(dataH,1),size(MTFdataH, 2));
MTFm = zeros(size(dataH,1),size(MTFdataH, 2));
MTFe = zeros(size(dataH,1),size(MTFdataH, 2));

% plot spatial distribution of Horizontal ROIs

h = figure('Name', 'spatial_dist_horizontal_ROIs');
title("spatial distribution of Horizontal ROIs")
hold on
grid on
xticks(0:rec_x:size(tt_img, 2))
yticks(0:rec_y:size(tt_img, 1))
p = repmat(polyshape, 1, (RDseg-1));
yCenter = s(1)/2;
xCenter = s(2)/2;
for v = 1:(RDseg-1)
    theta = (0:99)*(2*pi/100);
    x = xCenter + Rad(v)*cos(theta);
    y = yCenter + Rad(v)*sin(theta);
    P = polyshape(x,y);
    p(v) = P;
    pg = plot(P, 'DisplayName', ['RadDist-' num2str(v)]);
end
xptt = dataH(:,10);
yptt = dataH(:,11);
for i = 1:numel(numMTFsH)
    xpt = xptt(i);
    ypt = yptt(i);

    for n = 1:size(p,2)
        TFin = isinterior(p(n),xpt,ypt);
        if n==1 && TFin == 1
            MTFc(i,:) = MTFdataH(i,:);
            c = 'g.';
            ln = 'centre';
            plot(xpt,ypt,c, 'DisplayName', ln)
            break;
        elseif n==2 && TFin == 1
            MTFm(i,:) = MTFdataH(i,:);
            c = 'b.';
            ln = 'middle';
            plot(xpt,ypt,c, 'DisplayName', ln)
            break;
        elseif n==3 && TFin == 1
            MTFe(i,:) = MTFdataH(i,:);
            c = 'r.';
            ln = 'edge';
            plot(xpt,ypt,c, 'DisplayName', ln)
            break;
        end
    end
    Waitbartex=['Processing point...' ln];
    disp(Waitbartex)
    idx = getIndex(nx,ny,cols,rows,xpt,ypt);
    MTFidxH(i) = idx;
end
hold off;
set(gca, 'YDir','reverse') % flip Y axis
xlim([0 cols])
ylim([0 rows])

%plot mean SFR of each annuli
%MTFc = nonzeros(MTFc');
MTFc( ~any(MTFc,2), : ) = [];  %remove rows with zeros
MTFm( ~any(MTFm,2), : ) = [];  %remove rows with zeros
MTFe( ~any(MTFe,2), : ) = [];  %remove rows with zeros

h = figure('Name', 'mean_horizontal_MTFs_per_Annuli')
hold on;
plot(uq, mean(MTFc, 1), 'g', 'DisplayName', 'centre');
plot(uq, mean(MTFm, 1), 'b', 'DisplayName', 'middle');
plot(uq, mean(MTFe, 1), 'r', 'DisplayName', 'edge');
legend(legendUnq(h), 'Location', 'northeast', 'FontSize', 5)
xlim([0 1])
xlabel('cy/px')

%initialize mean distribution for spatial regions
MTFc = zeros(size(dataV,1),size(MTFdataV, 2));
MTFm = zeros(size(dataV,1),size(MTFdataV, 2));
MTFe = zeros(size(dataV,1),size(MTFdataV, 2));

% plot spatial distribution of Vertical ROIs
h = figure('Name', 'spatial_dist_vertical_ROIs');
hold on
grid on
xticks(0:rec_x:size(tt_img, 2))
yticks(0:rec_y:size(tt_img, 1))
title("spatial distribution of Vertical ROIs")
for v = 1:(RDseg-1)
    theta = (0:99)*(2*pi/100);
    x = xCenter + Rad(v)*cos(theta);
    y = yCenter + Rad(v)*sin(theta);
    P = polyshape(x,y);
    p(v) = P;
    plot(P, 'DisplayName', ['RadDist-' num2str(v)])
end

figs = cell(size(dataV, 1), 1);
xptt = dataV(:,10);
yptt = dataV(:,11);
for i = 1:numel(numMTFsV)
    xpt = xptt(i);
    ypt = yptt(i);
    xpN = uint8(xpt);
    ypN = uint8(ypt);
    for n = 1:size(p,2)
        TFin = isinterior(p(n),xpt,ypt);
        if n==1 && TFin == 1
            MTFc(i,:) = MTFdataV(i,:);
            c = 'g.';
            ln = 'centre';
            plot(xpt,ypt,c, 'DisplayName', ln)
            break;
        elseif n==2 && TFin == 1
            MTFm(i,:) = MTFdataV(i,:);
            c = 'b.';
            ln = 'middle';
            plot(xpt,ypt,c, 'DisplayName', ln)
            break;
        elseif n==3 && TFin == 1
            MTFe(i,:) = MTFdataV(i,:);
            c = 'r.';
            ln = 'edge';
            plot(xpt,ypt,c, 'DisplayName', ln)
            break;
        end
    end
    Waitbartex=['Processing point...' ln];
    disp(Waitbartex)
    idx = getIndex(nx,ny,cols,rows,xpt,ypt);
    MTFidxV(i) = idx;
end
%legend(legendUnq(h), 'Location', 'southoutside', 'Orientation','horizontal',...
%    'Box','off', 'FontSize', 5)

set(gca, 'YDir','reverse') % flip Y axis
xlim([0 cols])
ylim([0 rows])

%plot mean of each annuli
MTFc( ~any(MTFc,2), : ) = [];  %remove rows with zeros
MTFm( ~any(MTFm,2), : ) = [];  %remove rows with zeros
MTFe( ~any(MTFe,2), : ) = [];  %remove rows with zeros
h = figure('Name', 'mean_vertical_MTFs_per_Annuli')
hold on;
plot(uq, mean(MTFc, 1), 'g', 'DisplayName', 'centre');
plot(uq, mean(MTFm, 1), 'b', 'DisplayName', 'middle');
plot(uq, mean(MTFe, 1), 'r', 'DisplayName', 'edge');
legend(legendUnq(h), 'Location', 'northeast', 'FontSize', 5)
xlim([0 1])
xlabel('cy/px')
%% plot all ROI curves in heatmap
%initialize approx. locations of heatmap regions in annuli
MTFc_l = zeros(nx*ny,2);
MTFm_l = zeros(nx*ny,2);
MTFe_l = zeros(nx*ny,2);

h = figure('Name', 'all_horizontal_MTF');
hold on
grid on
xrange = 0:rec_x:size(tt_img, 2);
yrange = 0:rec_y:size(tt_img, 1);
title('All horizontal MTF curves (heatmap)')
for i = 1:ny
    for j = 1:nx
        idx = sub2ind([nx, ny], j, i);
        MTFbin = mean(MTFdataH(MTFidxH==idx,:));
        %MTFbin_l = mean(H_locations(MTFidxH==idx,:));
        %[xpt,ypt] = MTFbin_l(1:2);
        xpt = (xrange(j) + rec_x/2);
        ypt = (yrange(i) + rec_y/2);
        c='m';
        for n = 1:size(p,2)
            TFin = isinterior(p(n),xpt,ypt);
            if n==1 && TFin == 1
                MTFc_l(idx, :) = [xpt, ypt];
                ln = 'centre';
                c = 'g';
                break;
            elseif n==2 && TFin == 1
                MTFm_l(idx, :) = [xpt, ypt];
                ln = 'middle';
                c = 'b';
                break;
            elseif n==3 && TFin == 1
                MTFe_l(idx, :) = [xpt, ypt];
                ln = 'edge';
                c = 'r';
                break;
            elseif n==3 && TFin == 0
                MTFbin = 0;
                break;
            end
        end
        if MTFbin ~= 0
            plot(uq,MTFbin,c,'DisplayName', ln)
        end
    end
end
legend(legendUnq(h), 'Location', 'northeast', 'FontSize', 5)
xlim([0 1])
xlabel('cy/px')

% plot spatial distribution of heatmap regions
h = figure('Name', 'spatial_dist_heatmap_locations');
hold on
grid on
xticks(0:rec_x:size(tt_img, 2))
yticks(0:rec_y:size(tt_img, 1))
title("spatial distribution of Heatmap regions")
for v = 1:(RDseg-1)
    theta = (0:99)*(2*pi/100);
    x = xCenter + Rad(v)*cos(theta);
    y = yCenter + Rad(v)*sin(theta);
    P = polyshape(x,y);
    p(v) = P;
    plot(P, 'DisplayName', ['RadDist-' num2str(v)])
end

MTFc_l( ~any(MTFc_l,2), : ) = [];  %remove rows with zeros
MTFm_l( ~any(MTFm_l,2), : ) = [];  %remove rows with zeros
MTFe_l( ~any(MTFe_l,2), : ) = [];  %remove rows with zeros

plot(MTFc_l(:,1), MTFc_l(:,2), 'g.', 'DisplayName', 'centre', LineWidth=4)
plot(MTFm_l(:,1), MTFm_l(:,2), 'b.', 'DisplayName', 'middle', LineWidth=4)
plot(MTFe_l(:,1), MTFe_l(:,2), 'r.', 'DisplayName', 'edge', LineWidth=4)
%legend(legendUnq(h), 'Location', 'southoutside', 'Orientation','horizontal',...
%    'Box','off', 'FontSize', 5)
set(gca, 'YDir','reverse') % flip Y axis
xlim([0 cols])
ylim([0 rows])

%plot all mean vertical MTFs in heatmap regions
h = figure('Name', 'all_vertical_MTF');
hold on
title('All vertical MTF curves (heatmap)')
for i = 1:ny
    for j = 1:nx
        idx = sub2ind([nx, ny], j, i);
        MTFbin = mean(MTFdataV(MTFidxV==idx,:));
        xpt = (xrange(j) + rec_x/2);
        ypt = (yrange(i) + rec_y/2);
        c='m';
        for n = 1:size(p,2)
            TFin = isinterior(p(n),xpt,ypt);
            if n==1 && TFin == 1
                ln = 'centre';
                c = 'g';
                break;
            elseif n==2 && TFin == 1
                ln = 'middle';
                c = 'b';
                break;
            elseif n==3 && TFin == 1
                ln = 'edge';
                c = 'r';
                break;
            elseif n==3 && TFin == 0
                MTFbin = 0;
                break;
            end
        end
        if MTFbin ~= 0
            plot(uq,MTFbin,c,'DisplayName', ln)
        end
    end
end
legend(legendUnq(h), 'Location', 'northeast', 'FontSize', 5)
xlim([0 1])
xlabel('cy/px')

%% calculate mean MTF50, plot heat map
MTF50MeangridH = zeros(ny,nx);
for i = 1:ny
    for j = 1:nx
        idx = sub2ind([nx, ny], j, i);
        MTF50MeangridH(i,j) = mean(MTF50dataH(MTFidxH==idx,:));  
    end
end

colorLim = [0.2 0.4];

figure('Name', 'surface_plot_horizontal_MTF50_mean');
hHM = heatmap(MTF50MeangridH,'ColorLimits',colorLim)
title('Surface plot of horizontal MTF50 mean by region')
colorbar
hHM.NodeChildren(3).YDir = 'normal'; % flip Y axis


MTF50MeangridV = zeros(ny,nx);
for i = 1:ny
    for j = 1:nx
        idx = sub2ind([nx, ny], j, i);
        MTF50MeangridV(i,j) = mean(MTF50dataV(MTFidxV==idx,:));
    end
end

figure('Name', 'surface_plot_vertical_MTF50_mean');
hHM = heatmap(MTF50MeangridV,'ColorLimits',colorLim)
title('Surface plot of vertical MTF50 mean by region')
colorbar
hHM.NodeChildren(3).YDir = 'normal'; % flip Y axis

%% calculate standard deviation MTF50, plot heat map 

MTF50StdgridH = zeros(ny,nx);
for i = 1:ny
    for j = 1:nx
        idx = sub2ind([nx, ny], j, i);
        MTF50StdgridH(i,j) = std(MTF50dataH(MTFidxH==idx,:));  
    end
end

colorLim = [0.0 0.2];

figure('Name', 'surface_plot_horizontal_MTF50_std_dist');
hHM = heatmap(MTF50StdgridH,'ColorLimits',colorLim)
title('Surface plot of horizontal MTF50 standard deviation by region')
colorbar
hHM.NodeChildren(3).YDir = 'normal'; % flip Y axis


MTF50StdgridV = zeros(ny,nx);
for i = 1:ny
    for j = 1:nx
        idx = sub2ind([nx, ny], j, i);
        MTF50StdgridV(i,j) = std(MTF50dataV(MTFidxV==idx,:));
    end
end

figure('Name', 'surface_plot_vertical_MTF50_std_dist');
hHM = heatmap(MTF50StdgridV,'ColorLimits',colorLim)
title('Surface plot of vertical MTF50 standard deviaton by region')
colorbar
hHM.NodeChildren(3).YDir = 'normal'; % flip Y axis

%DJ - save all figures
FolderName = selpath;   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = get(FigHandle, 'Name');
  set(0, 'CurrentFigure', FigHandle);
  savefig(fullfile(FolderName, [FigName '.fig']));
  saveas(gcf, fullfile(FolderName, [FigName '.png']));
end
set(0, 'DefaultFigureVisible', 'on');
toc
disp('Completed System e-SFR Estimation');

function idx = getIndex(nx,ny,cols,rows,xpt,ypt)
    xedge = linspace(0,cols,nx+1);
    yedge = linspace(0,rows,ny+1);

    xbin = discretize(xpt, xedge);  % which column?
    ybin = discretize(-ypt, -yedge(end:-1:1));  % which row?
    idx = sub2ind([nx, ny], xbin, ybin); % translate row/column to index

end
