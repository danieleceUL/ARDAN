function [nmax,maxAt,maxValues,nmin,minAt,minValues, minAtIdx, maxAtIdx] = peakFinder(y,x,threshold,stepsize)
% This function detects the transition points (maxima and minima) of a
% function like y = f(x), where x is indpendent variable and y is dependent
% variable. If there is no clue about x, then use x = [], which is an empty
% vector, and if so, it automatically defines x = 1:length(y).
%
% Optional input arguments: threshold is the thresholding applied to y, and
% stepsize is the step size for computation of slopes. The smaller the
% stepsize is, the more accurate result is. By default stepsize =
% abs(x(1)-x(2))/10. 
%
% Finally, it returns, nmax: the number of peaks in y; maxAt: the x
% values at which peaks occur; maxValues: the peak values of y; nmin:
% number of minima in y; minAt: the x values at which minima occur; and
% minValues: the minima of y; (all after thresholding, if any).
%
% Examples 1: no threshodling
% x = -pi:pi/100:pi;
% y = sin(x)+cos(x.^2);
% [nmax,maxAt,maxValues,nmin,minAt,minValues] = findpeaks(y,x)
%
% Example 2: thresholding at 0
% x = -pi:pi/100:pi;
% y = sin(x)+cos(x.^2);
% [nmax,maxAt,maxValues,nmin,minAt,minValues] = findpeaks(y,x,0)
%
% Copyright @ Md Shoaibur Rahman (shoaibur@bcm.edu)

if nargin < 2 || isempty(x)
    x = 1:length(y);
end
if nargin < 3
    threshold = min(y);
end
if nargin < 4
    stepsize = abs(x(1)-x(2))/10;
end

y(y<threshold) = 0;

n = length(y);
a = zeros(1,n);

for i=1:n-1
    a(i) = (y(i+1)-y(i))/stepsize;
end
a(n) = a(n-1);

nmax = 0; nmin = 0; maxAt = []; maxValues = []; minAt = []; minValues = [];
maxAtIdx = [];
minAtIdx = [];
for k = 1:n-1
    if a(k)>0 && a(k+1)<=0
        nmax = nmax+1;        
        maxAt(nmax) = x(k+1);
        maxAtIdx(nmax) = (k+1);
        maxValues(nmax) = y(k+1);
    elseif a(k)<0 && a(k+1)>0
        nmin = nmin+1;
        minAt(nmin) = x(k+1);
        minAtIdx(nmin) = (k+1);
        minValues(nmin) = y(k+1);
    end
end