% Running Script to choose generated MTF plots from results and directories.
% Script will utilize PlotMTF50 function to extract and replot clearly the MTF50 results with legends

% Created by D. Jakab 2024, University of Limerick

close all;
clear all;
clc;
[selimg, path] = uigetfile({'*.fig'}, 'Select mean plot for MTF50');
openfig([path filesep selimg])
[spath, fn, sExt]= fileparts(selimg);
f = gcf;
set(f, 'visible', 'on');
mtf50data = PlotMTF50(fn)
mtf50data{:, 2}
mtf50data(any(cellfun(@(x)x(1)==0, mtf50data),2), :) = [];
[~, ix] = sort(mtf50data(1:end,1))   % sort the first column from 1st row onwards and get the indices
mtf50data(1:end,:) = mtf50data(ix,:)
%Write CSV data
fid = fopen([path filesep fn '_mtf50.csv'], 'w');
fprintf(fid, 'Category, MTF50\n')
size(mtf50data, 1)
for i = 1:size(mtf50data, 1)
    fprintf(fid, '%s,', mtf50data{i,1:end-1}) ;
    fprintf(fid, '%s\n', mtf50data{i,end}) ;
end
saveas(f, [path filesep fn '_mtf50'], 'fig')
saveas(f, [path filesep fn '_mtf50'], 'png')
fclose('all');