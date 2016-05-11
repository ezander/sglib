function [Qn_i_beta, V_qn, phi_func]=mmse_update_gpc(Q_i_alpha, Y_func, V_q, ym, eps_func, V_eps, p_phi, p_int_mmse, p_qn, p_int_proj, varargin)
% MMSE_UPDATE_GPC Update a GPC given some measurements and a measurement model.
%
% Example (<a href="matlab:run_example mmse_update_gpc">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.
options=varargin2options(varargin);
[int_grid,options]=get_option(options, 'int_grid', 'full_tensor');
check_unsupported_options(options, mfilename);

% Combine the bases of the a priori model (V_q) and of the error model
% (V_eps)
[V_qe, ind_V_q, ~, ind_xi_Q, ind_xi_eps] = gpcbasis_combine(V_q, V_eps, 'outer_sum');

% Create evaluation function for measurement + error model (YM_func) 
YM_func = @(xi)(...
    eval_on_subset(xi, Y_func, ind_xi_Q) + ...
    eval_on_subset(xi, eps_func, ind_xi_eps));

% Extend the GPC coefficients Q_i_alpha to the larger basis V_qn
Q_i_beta = zeros(size(Q_i_alpha,1), gpcbasis_size(V_qe,1));
Q_i_beta(:,ind_V_q) = Q_i_alpha;

[Qn_i_beta, V_qn, phi_func]=mmse_update_gpc_basic(Q_i_beta, YM_func, V_qe, ym, p_phi, p_int_mmse, p_qn, p_int_proj, 'int_grid', int_grid);


function y = eval_on_subset(xi, func, ind)
% EVAL_ON_SUBSET Evaluate function only on subset of input array
%   Y = EVAL_ON_SUBSET(XI, FUNC, IND) evaluates FUNC only on
%   XI_REDUCED=XI(:,IND). Since many of of the XI_REDUCED may be identical
%   they are made unique before and later put into the right place.

[xi_red, ~, ib] = unique(xi(ind, :)', 'rows');
xi_red = xi_red';
y_red = funcall(func, xi_red);
y = y_red(:,ib);
