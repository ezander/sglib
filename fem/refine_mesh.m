function [pos,els,P]=refine_mesh( pos, els, varargin )
% REFINE_MESH Refine a finite element mesh.
%   [NEWPOS,NEWELS]=REFINE_MESH( POS, ELS ) performs a global refinement on
%   the mesh specified in POS and ELS.
%
%   [NEWPOS,NEWELS,P]=REFINE_MESH( POS, ELS ) additionally returns a
%   prolongation matrix in P mapping nodes in the unrefined mesh to nodes
%   in the refined mesh (linear interpolation).
%
% Example (<a href="matlab:run_example refine_mesh">run</a>)
%   % show simple example on console
%   [pos, els] = create_mesh_2d_rect(0)
%   [pos, els] = refine_mesh(pos, els)
%   % plot with usage of pronlogation operator
%   [pos,els]=create_mesh_2d_rect(2);
%   z = (sin(5*pos(1,:)).*sin(7*pos(2,:)))';
%   clf;
%   subplot(1,2,1); plot_field(pos, els, z, 'view', [40, 25]);
%   [pos2, els2, P] = refine_mesh(pos, els);
%   z2 = P * z;
%   subplot(1,2,2); plot_field(pos2, els2, z2, 'view', [40, 25]);
%
% See also 

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

options = varargin2options(varargin, mfilename);
[num_refine, options]=get_option(options, 'num_refine', 1);
check_unsupported_options(options);

compute_prolongation = (nargout>=3);

if compute_prolongation
    npos=size(pos,2);
    P = speye(npos);
end

for i=1:num_refine
    [pos,els,Pn]=do_refine_mesh( pos, els, compute_prolongation );
    if compute_prolongation
        P = Pn * P;
    end
end

function [newpos,newels,P]=do_refine_mesh( pos, els, compute_prolongation )
% DO_REFINE_MESH Does the actual refinement.

npos=size(pos,2);
nels=size(els,2);

% extract edges and which edges belongs to which element
edges=[ els([1;2],:), els([2;3],:), els([3;1],:)];
eltoedge=reshape(1:(3*nels),[],3)';
% should hold: els==reshape( edges( 1, eltoedge ), 3, [] )

% extract unique edges and create new points on them (also keep relation to
% original edges in 'from')
uedges=sort(edges,1);
[uedges,to,from]=unique( uedges', 'rows' );
swallow(to);

ind1 = uedges(:,1);
ind2 = uedges(:,2);
addpos=0.5*(pos(:, ind1) + pos(:, ind2));
newpos=[pos, addpos];

% if requested construct prolongation matrix, mapping nodes in the
% unrefined mesh to nodes in the refined mesh (linear interpolation)
if compute_prolongation
    nedge = length(ind1);
    i = [ 1:npos, npos+(1:nedge), npos+(1:nedge)];
    j = [ 1:npos, ind1', ind2'];
    s = [ones(1,npos), 0.5*ones(1,2*nedge) ];
    P = sparse(i,j,s,npos+nedge, npos);
    %newpos - (P*pos')'
else
    P = [];
end

% define new elements using 'nonunique' points
nels=npos+[eltoedge(1,:); eltoedge(2,:); eltoedge(3,:)];
nels=[nels, [edges( 1, eltoedge(1,:) ); npos+eltoedge(1,:); npos+eltoedge(3,:)]];
nels=[nels, [edges( 1, eltoedge(2,:) ); npos+eltoedge(2,:); npos+eltoedge(1,:)]];
nels=[nels, [edges( 1, eltoedge(3,:) ); npos+eltoedge(3,:); npos+eltoedge(2,:)]];

% create mapping from 'from' index to map to unique points
map=[1:npos npos+from'];
newels=map(nels);

