function [V_phi, phi_j_beta]=approx_rvmap(y_j_alpha, x_i_alpha, V_xy, p_phi, p_int, varargin)
% APPROX_RVMAP Short description of approx_rvmap.
%   APPROX_RVMAP Long description of approx_rvmap.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example approx_rvmap">run</a>)
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


Nx = size(x_i_alpha, 1);
V_phi=gpcbasis_create('M', 'm', Nx, 'p', p_phi, 'full_tensor', ~true);

[xi_i, w_i] = gpc_integrate([], V_xy, p_int);

x_i = gpc_evaluate(x_i_alpha, V_xy, xi_i);
y_j = gpc_evaluate(y_j_alpha, V_xy, xi_i);
phi_i = gpc_eval_basis(V_phi, x_i);

A = phi_i * diag(w_i) * phi_i';
b = phi_i * diag(w_i) * y_j';
phi_j_beta = (A\b)';

%cond(A)
