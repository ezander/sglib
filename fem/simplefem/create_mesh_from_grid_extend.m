function [pos_ex, els_ex, pos, els, inner_ind]=create_mesh_from_grid_extend(X, Y, n, d)
% CREATE_MESH_FROM_GRID_EXTEND Short description of create_mesh_from_grid_extend.
%   [POS, ELS, INNER_IND]=CREATE_MESH_FROM_GRID_EXTEND(X, Y) Long description of create_mesh_from_grid_extend.
%
% Example (<a href="matlab:run_example create_mesh_from_grid_extend">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2016, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

assert(isvector(X));
assert(isvector(Y));

[pos, els] = create_mesh_from_grid(X, Y);

X = do_extend(X, n, d);
Y = do_extend(Y, n, d);
[pos_ex, els_ex] = create_mesh_from_grid(X, Y);

[~,inner_ind]=ismember(pos', pos_ex', 'rows');


function V=do_extend(V, n, d)
V = V(:);

dv1 = (V(2) - V(1));
n1 = max(n, ceil(d/dv1));
DV1 = (n1:-1:1)' * dv1;

dv2 = (V(end) - V(end-1));
n2 = max(n, ceil(d/dv2));
DV2 = (1:n2)' * dv2;

V = [V(1) - DV1; V; V(end) + DV2];
