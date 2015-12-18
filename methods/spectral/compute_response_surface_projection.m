function [u_i_alpha, model, xi_i_k, w_k] = compute_response_surface_projection(model, q_func, V_u, p_int, varargin)
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
[abstol,options]=get_option(options, 'abstol', 1e-6);
[steptol,options]=get_option(options, 'steptol', 1e-8);
check_unsupported_options(options, mfilename);

[xi_i_k,w_k] = gpc_integrate([], V_u, p_int, 'grid', grid);
M = gpcbasis_size(V_u, 1);
L = length(w_k);
u_i_alpha = multivector_init(model.model_info.num_vars, M);
q_j_k = funcall(q_func, xi_i_k);

for k = 1:L
    q_j = q_j_k(:, k);
    [u_i_k, model] = spmodel_solve(model, q_j, 'steptol', steptol, 'abstol', abstol);
    xi_i = xi_i_k(:, k);
    psi_i_alpha_dual = gpcbasis_evaluate(V_u, xi_i, 'dual', true);
    u_i_alpha = multivector_update(u_i_alpha, w_k(k), u_i_k, psi_i_alpha_dual);
end
