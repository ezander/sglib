function [u_i_alpha, x, w] = compute_response_surface_projection(init_func, solve_func, V_u, p_int, varargin)
% COMPUTE_RESPONSE_SURFACE_PROJECTION Compute a gpc response surface representation.
%   COMPUTE_RESPONSE_SURFACE_PROJECTION Long description of compute_response_surf_projection.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example compute_response_surface_projection">run</a>)
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

options=varargin2options(varargin);
[grid,options]=get_option(options, 'grid', 'smolyak');
check_unsupported_options(options, mfilename);

state = funcall(init_func);

[x,w] = gpc_integrate([], V_u, p_int, 'grid', grid);
M = gpcbasis_size(V_u, 1);
Q = length(w);
u_i_alpha = zeros(state.num_vars, M);

for j = 1:Q
    p_j = x(:, j);
    u_i_j = funcall(solve_func, state, p_j);
    psi_j_alpha_dual = gpc_eval_basis(V_u, p_j, 'dual', true);
    u_i_alpha = u_i_alpha + w(j) * u_i_j * psi_j_alpha_dual;
end
