% Running script to convert a heatmap of MTF50 values to a CSV file
% Created by D. Jakab 2024, University of Limerick
%Date: 04/03/2024
close all;
clear all;
clc;
selpath = uigetdir('experiment folder');
hMp2CSV(selpath, 'surface_plot_horizontal_MTF50_mean')
hMp2CSV(selpath, 'surface_plot_vertical_MTF50_mean')
disp(['finished']);
close all;
fclose('all');

function hMp2CSV(selpath, filename)
    openfig([selpath filesep filename]);
    hMp = gca;
    hMp = flip(hMp.ColorData)
    hMp(isnan(hMp)) = 0;
    writematrix(hMp,[selpath filesep filename '.csv'])
end
