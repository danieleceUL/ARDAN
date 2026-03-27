%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Date: 26/03/2024
%   Name: Daniel Jakab
%   Description: Assigns an index to all extracted data points in NS-SFR
%                analysis.
%   Copyright (c) 2023 D. Jakab
%   UNIVERSITY OF Limerick PhD Research
%              - D2ICE Research Group
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function idx = getIndex(nx,ny,cols,rows,xpt,ypt)
    xedge = linspace(0,cols,nx+1);
    yedge = linspace(0,rows,ny+1);

    xbin = discretize(xpt, xedge);  % which column?
    ybin = discretize(-ypt, -yedge(end:-1:1));  % which row?
    idx = sub2ind([nx, ny], xbin, ybin); % translate row/column to index

end
