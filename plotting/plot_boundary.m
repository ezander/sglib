function plot_boundary( pos, els, varargin )
% PLOT_BOUNDARY Plots the boundary of a triangular 2D mesh.
%   PLOT_BOUNDARY( POS, ELS, VARARGIN ) plots boundary of the mesh
%   specified by the node data in POS (2XNUM_NODES) and element data ELS
%   (2xNUM_ELEMS). The boundary is automatically determined as the lines
%   which appear only once in the element data.
%
% Options:
%   zpos: {0}
%     The z position where the lines are drawn. If some field is overlayed
%     it may make sense to move the drawing of the boundary away from 0.
%   color: {'k'}
%     The color of the boundary lines.
%   width: {1}
%     The line width of the boundary lines.
%
% Example (<a href="matlab:run_example plot_boundary">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


check_boolean( size(els,1)==3, 'elements must be triangles (size(els,1)==3)', mfilename );
check_range( size(pos,1), 2, 2, 'sizeof(pos,1)', mfilename );

options=varargin2options( varargin );
[zpos,options]=get_option( options, 'zpos', 0 );
[color,options]=get_option( options, 'color', 'k' );
[linestyle,options]=get_option( options, 'linestyle', '-' );
[width,options]=get_option( options, 'width', 1 );
[bnd,options]=get_option( options, 'bndedges', '' );
check_unsupported_options( options, mfilename );

if isempty(bnd) && ischar(bnd)
    bnd=find_boundary( els, false );
end

plot_lines(pos,bnd,'zpos', zpos, 'line_opts', {'color', color, 'linestyle', linestyle, 'linewidth', width} );
