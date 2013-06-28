function [y_relerr, xi] = compute_mc_error(y_j_beta, V_y, x_i_alpha, V_x, phi_j_gamma, V_phi, N)
% COMPUTE_MC_ERROR Short description of compute_mc_error.
%   COMPUTE_MC_ERROR Long description of compute_mc_error.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example compute_mc_error">run</a>)
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

xi = gpc_sample(V_x, N, 'mode', 'lhs');

x = gpc_evaluate(x_i_alpha, V_x, xi);
y = gpc_evaluate(y_j_beta, V_y, xi);

y_approx = gpc_evaluate(phi_j_gamma, V_phi, x);

y_relerr = (sum((y-y_approx).^2, 2)/N) ./ (sum(y.^2, 2)/N);
