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