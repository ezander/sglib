function dist=scaled_distance(x1, x2, l, smooth)
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

if isempty(x2)
    dx=x1;
else
    dx=x1-x2;
end

d=size(dx,1);
if d==1
    dist=abs(dx/l);
elseif isscalar(l)
    dist=sqrt(sum( (dx/l).^2, 1));
else
    invl=diag(1./l);
    dist=sqrt(sum( (invl*dx).^2, 1));
end

if smooth>0
    dist=sqrt(dist.^2+smooth^2)-smooth;
end
