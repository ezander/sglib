function [pos,els]=correct_mesh( pos, els )
% CORRECT_MESH Corrects the orientation of the elements of a 2D mesh.
%   [POS,ELS]=CORRECT_MESH( POS, ELS ) returns modified ELS such that the
%   determinant of each element is positive. 
%   Further, unused nodes are removed from POS and the corresponding (and
%   following) entries in ELS are reindexed.
%
% Example (<a href="matlab:run_example correct_mesh">run</a>)
%    % In this example the second node is removed and in the second element
%    % the ordering of the nodes is changed
%    pos=[0, 0; 7, 7; 1, 0; 1, 1; 0, 1]'
%    els=[1, 3, 4; 1, 5, 4]'
%    [pos, els] = correct_mesh(pos, els)
%
% See also REFINE_MESH, MESH_PARAMETERS

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


% Remap indices in ELS and POS such that they are contiguous from 1 to the
% number of nodes
ind=unique(sort(els(:)));
num_ind=size(ind,1);
if max(ind)~=num_ind
    old2new(ind)=1:num_ind;
    els=old2new(els);
    pos=pos(:,ind);
end

% Check the determinant for each element and swap the first two nodes if
% it's negative
T=size(els,2);
for t=1:T
    nodes=els(:,t);
    coords=pos(:,nodes);

    J=[ones(1,size(coords,2)); coords];
    if det(J)<0
        els([1,2],t)=els([2,1],t);
    end
end
