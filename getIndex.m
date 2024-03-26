function idx = getIndex(nx,ny,cols,rows,xpt,ypt)
    xedge = linspace(0,cols,nx+1);
    yedge = linspace(0,rows,ny+1);

    xbin = discretize(xpt, xedge);  % which column?
    ybin = discretize(-ypt, -yedge(end:-1:1));  % which row?
    idx = sub2ind([nx, ny], xbin, ybin); % translate row/column to index

end