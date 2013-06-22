function show_mesh_with_points( pos, els, x, varargin)
% SHOW_MESH_WITH_POINTS Short description of show_mesh_with_points.
%   SHOW_MESH_WITH_POINTS Long description of show_mesh_with_points.
%
% Example (<a href="matlab:run_example show_mesh_with_points">run</a>)
%
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

options=varargin2options(varargin);
[MarkerSize,options]=get_option( options, 'MarkerSize', 5 );
[zpos,options]=get_option( options, 'zpos', 0.1 );
check_unsupported_options(options, mfilename);

was_hold=ishold;

colors='bkrcmyg';
if ~was_hold; clf; end
plot_mesh( pos, els, 'color', [0.3,0.3,0.3] );
plot_boundary( pos, els );
    
axis equal
for i=1:size(x,2)
    line( x([1;1],i),  x([2;2],i), [zpos;zpos], 'Marker', '+', 'MarkerEdgeColor', colors(i), 'MarkerSize', MarkerSize, 'LineWidth', round(MarkerSize/3));
end
