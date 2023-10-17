function [R, RD] = RadAnnuli_custom(num, roi, tt_img)
% RadAnnuli - Segments the image frame into even area Radial Annuli
% Input:
%   im       Image frame to segment
%   num      The number if Radial Annuli to segment the frame into
%   ROImask   mask of ROI on images
%   tt_img    Test image from dataset for radial distance and mask
%             projection
%
% Output:
%   R        The Radius of each Annuli
%   RD       Segmented frame 
%   
% Copyright (c) 2023 D. Jakab
% UNIVERSITY OF Limerick PhD Reserch
%              - D2ICE Research Group

% Image area per segment

% Set radius list (one less to avoid outermost segment - aperture)
R = zeros(1,(num-1));
mask = roi.h;
ml = logical(mask);
A = bwarea(mask);
%a = A/num;
[Y, X] = size(mask);
% im centure
y_c = round(Y/2);
x_c = round(X/2);
xCenter = x_c;
yCenter = y_c;
% Display the image.
h = figure('Name', 'custom radial segments')
image(tt_img);
p3 = gca();
axis(p3, 'on', 'xy');
hold on;
xlim([0 X])
ylim([0 Y])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Custom Radial annuli using ROI mask Euclidean Distance of mask
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the Euclidean Distance Transform of ROI mask
if any(ml ~= 1, 'all')
    % Convert ROI mask into polygon
    P = mask2poly(logical(mask));
    pgon = polyshape(P.X, P.Y);
    x = P.X;
    y = P.Y;
    %find maximum euclidean distance (from furthest edge to centre)
    distanceFromEdge = max(sqrt((xCenter-x).^2 + (yCenter-y).^2));
    plot(x, y, 'r-', 'LineWidth' , 3, 'MarkerSize', 30);
    %legend('ROImask', 'FontSize', 10)
else
    %no mask present
    distanceFromEdge = sqrt((xCenter-X).^2 + (yCenter-Y).^2);
end
p3.YDir = 'reverse';
radius = distanceFromEdge;
%viscircles(p3, [x_c, y_c], radius);
R(1,(num-1)) = radius;

% Display circles over edt image.

rectangle('Position',[xCenter-radius yCenter-radius 2*radius 2*radius],...
    'Curvature',[1,1], 'LineWidth', 3, 'EdgeColor', '#EDB120');
%iterate over middle two annuli to scale radius with 0.6 and 0.4 ratio (sufficient for spacing)
for N=size(R,2):-1:2
    radius = radius * (N/(num+1));
    rectangle('Position',[xCenter-radius, yCenter-radius, 2*radius, 2*radius],...
        'Curvature',[1,1], 'LineWidth',3, 'EdgeColor', 'y');
    R(1,(N-1)) = radius;
end

%legappend('inner RadDist')
%Project plot onto first image of dataset
hold off;

title('Custom Radial Annuli restricted to ROI mask', 'FontSize', 12);
xlabel('pixels (width)');
ylabel('pixels (height)');

RD = zeros(Y, X); 
[columnsInImage, rowsInImage] = meshgrid(1:X, 1:Y);
for rd = size(R,2):-1:1
    radius = R(1,rd);
    circlePixels = (rowsInImage - yCenter).^2 ...
    + (columnsInImage - xCenter).^2 <= radius.^2;
    RD(circlePixels)=rd;
end
