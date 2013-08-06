function [u_i_alpha, x] = compute_response_surface_tensor_interpolate(init_func, solve_func, V_u, p_u)
% COMPUTE_RESPONSE_SURFACE_TENSOR_INTERPOLATE Short description of compute_response_surface_tensor_interpolate.
%   COMPUTE_RESPONSE_SURFACE_TENSOR_INTERPOLATE Long description of compute_response_surface_tensor_interpolate.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example compute_response_surface_tensor_interpolate">run</a>)
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

% compute interpolation points (need one level more than order)
[x,w] = gpc_integrate([], V_u, p_u+1, 'grid', 'full_tensor');

% compute the (generalised) Vandermonde matrix
A=gpcbasis_evaluate(V_u, x);


Q = length(w);
u = zeros(state.num_vars, Q);
for j = 1:Q
    x_j = x(:,j);
    u(:,j) = funcall(solve_func, state, x_j);
end

u_i_alpha = u/A;

% the next line should go into a unit test
%   norm(gpc_evaluate(u_i_alpha, V_u, x)-u)
