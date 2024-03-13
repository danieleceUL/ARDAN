% Running Script to count the number of points per heatmap grid

% Created by D. Jakab 2024, University of Limerick

close all;
clear all;
clc;
selpath = uigetdir('experiment folder');
openfig([selpath filesep 'spatial_dist_heatmap_locations.fig'])
outh = readtable([selpath filesep 'horizontal.csv'])
outv = readtable([selpath filesep 'vertical.csv'])
f = gcf;
set(f, 'visible', 'on');
ygridvals = f.Children.YTick;
xgridvals = f.Children.XTick;
centroidh = [outh(:,"Var10"), outh(:,"Var11")];
centroidv = [outv(:,"Var10"), outv(:,"Var11")];
centroidh = table2array(centroidh)
centroidv = table2array(centroidv)
xgridvals
ygridvals
countHGrid = countPoints(centroidh, xgridvals, ygridvals);
countVGrid = countPoints(centroidv, xgridvals, ygridvals);
format long
countHGrid
countVGrid
figure(2)
hmpHct = heatmap(countHGrid)
figure(3)
hmpVct = heatmap(countVGrid)

saveas(hmpHct, [selpath filesep 'horizontal_points_per_grid'], 'fig')
saveas(hmpHct, [selpath filesep 'horizontal_points_per_grid'], 'png')
saveas(hmpVct, [selpath filesep 'vertical_points_per_grid'], 'fig')
saveas(hmpVct, [selpath filesep 'vertical_points_per_grid'], 'png')
writematrix(countVGrid,[selpath filesep 'vertical_points_per_grid.csv'])
writematrix(countHGrid,[selpath filesep 'horizontal_points_per_grid.csv'])
close all;
fclose('all');

function countGrid = countPoints(centroid, xgridvals, ygridvals)
    % countGrid - Count the number of data points per grid from a heatmap of locations where slanted edges have been measured.
    %
    % Input:
    %    centroid:      an array of centroid locations of x and y for each slanted edge location.
    %    xgridvals:     the x ticks of the heatmap grid where the image size is divided into a certain number of pixel grid locations e.g. 8. 
    %    ygridvals:     the y ticks of the heatmap grid where the image size is divided into a certain number of pixel grid locations e.g. 5.
    %
    % Output:
    %    countGrid:     A two dmensional matrix containing a count of the number of points per grid area.

    % Created by D. Jakab 2024, University of Limerick
    countGrid = zeros(5,8);
    for i = 1:(size(countGrid,1) +1)
        for j = 1:(size(countGrid,2) + 1)
            for n = 1:size(centroid,1)
                if (i > 1) && (j > 1)
                    if (centroid(n,1) >= xgridvals(j-1)) && (centroid(n,1) < xgridvals(j)) && (centroid(n,2) < ygridvals(i)) && (centroid(n,2) >= ygridvals(i-1))
                        countGrid(i-1,j-1) = countGrid(i-1,j-1) + 1;
                    end
                end
            end
        end 
    end
end