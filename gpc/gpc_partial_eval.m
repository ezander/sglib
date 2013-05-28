function [b_i_alpha, V_b] = gpc_partial_eval(a_i_alpha, V_a, k, xi)
% GPC_PARTIAL_EVAL Short description of gpc_partial_eval.
%   GPC_PARTIAL_EVAL Long description of gpc_partial_eval.
%
% Example (<a href="matlab:run_example gpc_partial_eval">run</a>)
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

[polys, I_a] = deal(V_a{:});

% TODO: currently this function works only when all polynomials in the gpc
% are the same
assert(length(polys)==1);

m = size(I_a,2);
p = max(I_a(:));
V_k = {polys, (0:p)'};
v_k = gpc_evaluate(eye(p+1), V_k, xi);

I_ak = I_a(:,k);
I_a(:,k) = [];
I_b = multiindex(m-1, p);

ind = multiindex_find(I_a, I_b);
P = sparse(1:length(ind), ind, v_k(I_ak+1));

b_i_alpha = a_i_alpha * P;
V_b = {polys, I_b};
