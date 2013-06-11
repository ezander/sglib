function plot_mesh( pos, els, varargin )
% PLOT_MESH Plots a triangular 2D mesh.
%   PLOT_MESH( POS, ELS, VARARGIN ) plots the mesh specified by the node
%   data in POS (2XNUM_NODES) and element data ELS (2xNUM_ELEMS). 
%
% Options:
%   zpos: {0}
%     The z position where the mesh is drawn. If some field is overlayed it
%     may make sense to move the mesh away from 0.
%   color: {'k'}
%     The color of the mesh lines.
%   width: {1}
%     The line width of the mesh lines.
%   bndcolor: {'k'}
%     The color of the boundary lines.
%   bndwidth: {1}
%     The line width of the boundary lines.
%
% Example (<a href="matlab:run_example plot_mesh">run</a>)
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

check_boolean( size(els,1)==3, 'elements must be triangles (size(els,1)==3)', mfilename );
check_range( size(pos,1), 2, 2, 'sizeof(pos,1)', mfilename );

options=varargin2options( varargin );
[zpos,options]=get_option( options, 'zpos', 0 );
[color,options]=get_option( options, 'color', 'k' );
[width,options]=get_option( options, 'width', 1 );
[bndcolor,options]=get_option( options, 'bndcolor', 'k' );
[bndwidth,options]=get_option( options, 'bndwidth', 1 );
check_unsupported_options( options, mfilename );

edges=[ els([1;2],:), els([2;3],:), els([3;1],:)];
edges=sort(edges,1);
edges=unique( edges', 'rows' )';

plot_lines(pos,edges,'zpos', zpos, 'line_opts', {'color', color, 'linewidth', width} );

if ~isequal( color, bndcolor ) || ~isequal( width, bndwidth )
    plot_boundary( pos, els, 'zpos', zpos, 'color', bndcolor, 'width', bndwidth );
end


