function show_mesh_with_points( pos, els, x, varargin)
% SHOW_MESH_WITH_POINTS Short description of show_mesh_with_points.
%   SHOW_MESH_WITH_POINTS Long description of show_mesh_with_points.
%
% Example (<a href="matlab:run_example show_mesh_with_points">run</a>)
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

colors='bkrcmyg';
plot_mesh( pos, els, 'color', [0.3,1,0.3] );
plot_boundary( pos, els );
    
axis equal
for i=1:size(x,2)
    line( x([1;1],i),  x([2;2],i), [0.08;0.08], 'Marker', '+', 'MarkerEdgeColor', colors(i));
end
hold off;
