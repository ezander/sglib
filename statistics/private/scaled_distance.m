function dist=scaled_distance(x1, x2, l, smooth, sqr)
% SCALED_DISTANCE Computes the scaled distance between points.
%   DIST=SCALED_DISTANCE(X1, X2) computes the Euclidean distance between
%   points given in X1 and X2.
%
%   DIST=SCALED_DISTANCE(X1, X2, L) computes the Euclidean distance between
%   X1 and X2 scaled by L where L can be scalar or a vector of the same
%   dimension as the points in X1 and X2.
%
%   DIST=SCALED_DISTANCE(X1, X2, L, SMOOTH) computes the smoothed
%   Euclidean distance where the smoothing function is given by
%   D_SMOOTH=SQRT(D+SMOOTH^2)-SMOOTH.
%   
%   DIST=SCALED_DISTANCE(X1, X2, L, SMOOTH, SQR) returns the square of the
%   Eudclidean smoothed, scaled distance. This saves computing the square
%   root if only the square is needed by the calling code anyway.
%
%   Note: if an empty array is specified for a parameter the default value
%   is used. DIST=SCALED_DISTANCE(X1, X2, [], [], TRUE) computes the square
%   of the distance with parameters L and SMOOTH set to their defaults 1
%   and 0.
%
% Example (<a href="matlab:run_example scaled_distance">run</a>)
%     d=linspace(-1,1);
%     plot(d, scaled_distance(d, [], [], 0)); hold all;
%     plot(d, scaled_distance(d, [], [], 1));
%     plot(d, scaled_distance(d, [], [], 2));
%     plot(d, scaled_distance(d, [], 0.3, 0));
%     plot(d, scaled_distance(d, [], 0.3, 1));
%     plot(d, scaled_distance(d, [], 0.3, 2)); hold off;
%     axis equal;
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<5 || isempty(sqr)
    sqr=false;
end
if nargin<4 || isempty(smooth)
    smooth=0;
end
if nargin<3 || isempty(l)
    l=1;
end


if isempty(x2)
    dx=x1;
else
    dx=x1-x2;
end

d=size(dx,1);
if isscalar(l)
    dx=dx/l;
elseif length(l)==d
    invl=diag(1./l);
    dx=invl*dx;
else
    error( 'statistics:scaled_distance', 'Size of cov_length vector doesn''t match dimension. Transposed?' );
end
dist2=sum( dx.*dx, 1);

if sqr
    if smooth>0
        dist=sqrt(dist2+smooth^2)-smooth;
        dist=dist.*dist;
    else
        dist=dist2;
    end
else
    if smooth>0
        dist=sqrt(dist2+smooth^2)-smooth;
    else
        dist=sqrt(dist2);
    end
end

