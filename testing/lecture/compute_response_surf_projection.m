function [V_u, u_i_alpha] = compute_response_surf_projection(init_func, solve_func, polysys, order, p, varargin)
% COMPUTE_RESPONSE_SURF_PROJECTION Compute a gpc response surface representation.
%   COMPUTE_RESPONSE_SURF_PROJECTION Long description of compute_response_surf_projection.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example compute_response_surf_projection">run</a>)
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

state = funcall(init_func);

I = multiindex(state.num_params, order);
V_u = {polysys, I}; 

[x,w] = gpc_integrate([], V_u, p);

M = size(I,1);
N = size(x,2);
u_i_alpha = zeros(state.num_vars, M);

% something with the norm is not quite right
nrm2 = gpc_norm(V_u, 'sqrt', false);

for k = 1:N
    p_k = x(:, k);
    u_i_k = funcall(solve_func, state, p_k);
    psi_k_alpha = gpc_eval_basis(V_u, p_k);
    u_i_alpha = u_i_alpha + w(k) * u_i_k * (psi_k_alpha ./ nrm2)';
end
