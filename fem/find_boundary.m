function bnd=find_boundary(els, points_only)
% FIND_BOUNDARY Determins the boundary nodes in 1D and 2D meshes.
%  BND=FIND_BOUNDARY(ELS, POINTS_ONLY) returns the indices that belong to
%  boundary nodes for the elements specified in ELS. In 2D if POINTS_ONLY
%  is false only the nodes themselves are returned, if true (which is the
%  default) the edges are returned. In 1D this makes no difference, so this
%  option is ignored.
%
% Example (<a href="matlab:run_example find_boundary">run</a>)
%   [pos,els]=create_mesh_2d_rect(3);
%   underline('Boundary edges');
%   bnd_edges = find_boundary(els)
%   underline('Boundary nodes');
%   bnd_nodes = find_boundary(els, true)
%
% See also CLEAR_NON_BOUNDARY_VALUES, PLOT_BOUNDARY, PLOT_BOUNDARY_CONDS

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<2
    points_only=false;
end

d=size(els,1)-1;
switch d
    case 1
        bnd=find_boundary_1d( els );
    case 2
        bnd=find_boundary_2d( els, points_only );
    otherwise
        error('simplefem:find_boundary:param_error', 'Unsupported dimension: %d. Maybe you have to pass your position vector transposed?', d);
end


function bnd=find_boundary_1d( els )
% FIND_BOUNDARY_1D Find edges in 1D mesh.
edgs=[els(1,:), els(2,:)];
bnd=find_boundary_from_edges( edgs );

function bnd=find_boundary_2d( els, points_only )
% FIND_BOUNDARY_2D Find edges in 2D mesh.
edgs=[els([1;2],:), els([2,3],:), els([3;1],:)];
bnd=find_boundary_from_edges( edgs );
if points_only
    bnd=unique( bnd(:) )';
end

function bnd=find_boundary_from_edges( edgs )
% FIND_BOUNDARY_FROM_EDGES Returns those edges that appear only once.
edgs=sort(edgs,1);
edgs=sortrows(edgs')';
asnext=all(edgs(:,1:end-1)==edgs(:,2:end),1);
bndind=~([0,asnext]|[asnext,0]);
bnd=edgs(:,bndind);
