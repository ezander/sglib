function dist=scaled_distance(x1, x2, l, smooth, sqr)
% SCALED_DISTANCE Short description of scaled_distance.
%   SCALED_DISTANCE Long description of scaled_distance.
%
% Example (<a href="matlab:run_example scaled_distance">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<5
    sqr=false;
end
if nargin<4
    smooth=0;
end
if nargin<3
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

