% An extraction of MTF50 values from a heatmap in a MATLAB figure, saved as a CSV file where all MTF50 values.
% Are printed out on MATLAB command line.

% Created by D. Jakab 2024, University of Limerick
close all;
clear all;
clc;
[selimg, path] = uigetfile({'*.fig'}, 'Select mean plot for MTF50');
f2 = openfig([path filesep 'spatial_dist_heatmap_locations'])
h = findobj(gca,'Type','line');
x=get(h,'Xdata');
y=get(h,'Ydata');
fig = openfig([path filesep selimg])
[spath, fn, sExt]= fileparts(selimg);
f = gcf;
set(f, 'visible', 'on');

%extract mtf50 values from heatmap
ax = fig.Children
hmpmtf50 = ax.ColorData
%Write CSV data
fid = fopen([path filesep fn '.csv'], 'w');
fprintf(fid, 'Category, MTF50\n')

for i = 1:size(hmpmtf50, 1)
    for j = 1:size(hmpmtf50, 2)
        if ((i == 1) || (i == 5)) && ((j < 3) || (j > 6))
           fprintf(fid, '%s,', get(h(1), 'DisplayName')) ;
        elseif ((i == 1) || (i == 5)) && ((j >= 3) || (j <= 6))
           fprintf(fid, '%s,', get(h(2), 'DisplayName')) ;
        elseif ((i == 2) || (i == 4)) && ((j < 3) || (j > 6))
           fprintf(fid, '%s,', get(h(1), 'DisplayName')) ;
        elseif ((i == 2) || (i == 4)) && ((j == 3) || (j == 6))
           fprintf(fid, '%s,', get(h(2), 'DisplayName')) ;
        elseif ((i == 2) || (i == 4)) && ((j == 4) || (j == 5))
           fprintf(fid, '%s,', get(h(3), 'DisplayName')) ;
        elseif (i == 3) && ((j == 1) || (j == 8))
           fprintf(fid, '%s,', get(h(1), 'DisplayName')) ;   
        elseif (i == 3) && (((j > 1) && (j < 4)) || ((j > 5) && (j < 8)))
           fprintf(fid, '%s,', get(h(2), 'DisplayName')) ;
        else
           fprintf(fid, '%s,', get(h(3), 'DisplayName')) ;  
        end
        fprintf(fid, '%s\n', hmpmtf50(i,j)) ;
    end
end
fclose('all');
