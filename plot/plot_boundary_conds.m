function plot_boundary_conds( pos, els, varargin )
% PLOT_BOUNDARY_CONDS Short description of plot_boundary_conds.
%   PLOT_BOUNDARY_CONDS Long description of plot_boundary_conds.
%
% Example (<a href="matlab:run_example plot_boundary_conds">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Institute of Scientific Computing, TU Braunschweig.
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
[meshcolor,options]=get_option( options, 'meshcolor', 'k' );
[dircolor,options]=get_option( options, 'dircolor', 'r' );
[dirstyle,options]=get_option( options, 'dirstyle', '-' );
[neucolor,options]=get_option( options, 'neucolor', 'b' );
[neustyle,options]=get_option( options, 'neustyle', '-.' );
[meshwidth,options]=get_option( options, 'meshwidth', 1 );
[bndwidth,options]=get_option( options, 'bndwidth', 2 );
[neumann_nodes,options]=get_option( options, 'neumann_nodes', [] );
check_unsupported_options( options, mfilename );

edges=find_boundary( els, false );
nodemap=false( 1, size(pos,2) );
nodemap(neumann_nodes)=true;
neumann_edges=edges(:,any(nodemap(edges), 1));

nodemap=true( 1, size(pos,2) );
nodemap(neumann_nodes)=false;
dirichlet_edges=edges(:,any(nodemap(edges), 1));

plot_mesh( pos, els, 'color', meshcolor, 'width', meshwidth, 'zpos', zpos )
plot_boundary( pos, els, 'color', neucolor, 'linestyle', neustyle, 'zpos', zpos, 'bndedges', neumann_edges, 'width', bndwidth )
plot_boundary( pos, els, 'color', dircolor, 'linestyle', dirstyle, 'zpos', zpos, 'bndedges', dirichlet_edges, 'width', bndwidth )
axis equal
view(3)
