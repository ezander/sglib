function [phi_i_delta, V_phi]=mmse_estimate(Q_func, Y_func, V, p_phi, p_int, varargin)
% MMSE_ESTIMATE Compute the MMSE estimator.
%   [PHI_I_DELTA, V_PHI]=MMSE_ESTIMATE(Q_FUNC, Y_FUNC, V, P_PHI, P_INT,
%   OPTIONS) computes the minimum mean square error estimator PHI that
%   minimises the error between Q and PHI(Y). Here, Q is given by the
%   function Q_FUNC, Y by the function Y_FUNC, and both are defined on the
%   same GPC germ V. PHI is represented by multivariate polynomials of
%   maximum degree P_PHI. The coefficients are returned in PHI_I_DELTA, and
%   the system of polynomials if described by V_PHI (same for other GPC
%   functions). The one dimensional basis polynomials are the monomials by
%   default, but that can be changed using the POLYSYS option. P_INT is the
%   order of integration used.
%
% Options
%    'syschar': {'M'}, 'p', 'P', 'U', 'T', 'H', ...
%       The polynomial system used for representing PHI. Any sort of GPC
%       basis polynomial can be used.
%    'cond_warning': double, {inf}
%       A treshold value for the condition number of the linear system that
%       needs to be solved. If the condition number estimate is higher a
%       warning message is shown.
%
% References
%    [1] http://en.wikipedia.org/wiki/Minimum_mean_square_error
%    [2] D. P. Bertsekas and J. N. Tsitsiklis, Introduction to probability,
%        2 ed., Athena Scientific, 2008. 
%
% Example (<a href="matlab:run_example mmse_estimate">run</a>)
%    
% See also GPC, MMSE_ESTIMATE_GPC

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
[cond_warning,options]=get_option(options, 'cond_warning', inf);
[syschar,options]=get_option(options, 'syschar', 'M');
[int_grid,options]=get_option(options, 'int_grid', 'full_tensor');
check_unsupported_options(options, mfilename);

% Generate integration points
[xi_j_k, w_k] = gpc_integrate([], V, p_int, 'grid', int_grid);

% Evaluate Q and Y at the integration points
Q_i_k = funcall(Q_func, xi_j_k);
Y_j_k = funcall(Y_func, xi_j_k);

% Determine dimension of codomain of Y and create 
% function basis V_phi
m = size(Y_j_k, 1);
V_phi=gpcbasis_create(syschar, 'm', m, 'p', p_phi);
Psi_delta_k = gpcbasis_evaluate(V_phi, Y_j_k);

% Compute matrix A and right hand side b and solve
wPsi_k_delta = binfun(@times, Psi_delta_k', w_k);
A = Psi_delta_k * wPsi_k_delta;
b = Q_i_k * wPsi_k_delta;

phi_i_delta = (A\b')';


% Issue warning if the condition number is too high
if isfinite(cond_warning)
    kappa = condest(A);
    if kappa>=cond_warning
        warning('sglib:mmse_estimate_gpc:cond', ...
            'Condition number of matrix too large (%g), function approximation may be inaccurate', ...
            kappa);
    end
end
