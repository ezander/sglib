function [Qn_i_beta, V_qn, phi_func]=mmse_update_gpc_basic(Q_i_alpha, Y_func, V_qy, ym, p_phi, p_int_mmse, p_qn, p_int_proj, varargin)
% MMSE_UPDATE_GPC_BASIC Short description of mmse_update_gpc_basic.
%   MMSE_UPDATE_GPC_BASIC Long description of mmse_update_gpc_basic.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example mmse_update_gpc_basic">run</a>)
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

% Convert the GPC expansion of Q into a function object
Q_func = gpc_function(Q_i_alpha, V_qy);

% Now compute the MMSE estimator for Q given Y and make a function
% out of this estimator
[phi_j_delta,V_phi]=mmse_estimate(Q_func, Y_func, V_qy, p_phi, p_int_mmse, 'int_grid', int_grid);
phi_func = gpc_function(phi_j_delta, V_phi);

% Create the prediction stochastic model for Q as function
% composition between Y and phi and compute its GPC expansion
[V_qn, Pr_qyn] = gpcbasis_modify(V_qy, 'p', p_qn);
QM_func = funcompose(Y_func, phi_func);
QM_i_beta = gpc_projection(QM_func, V_qn, p_int_proj);

% Compute the best estimator value qm=phi(ym)
qm = funcall(phi_func, ym);

% Subtract the old coefficients to get the update and add qm
Qn_i_beta =  Q_i_alpha * Pr_qyn - QM_i_beta;
Qn_i_beta(:,1) = qm;

% The updated model Qn and the update should be orthogonal
%assert(norm(gpc_covariance(qn_i_alpha, V_q, qm_i_alpha))<1e-10)

% The new model and the update should be orthogonal
CQn = norm(gpc_covariance(Qn_i_beta, V_qn), 'fro');
CQnQM = norm(gpc_covariance(Qn_i_beta, V_qn, QM_i_beta), 'fro');
if CQnQM>1e-10*CQn
    warning('sglib:mmse_update_gpc_basic', 'gpc update not orthogonal (%g>1e-10*%g)', CQnQM, CQn);
end
[~, Q_var] = gpc_moments(Q_i_alpha, V_qy);
[~, Qn_var]= gpc_moments(Qn_i_beta, V_qn);
if any(Q_var - Qn_var<-1e-10)
    %keyboard
    warning('sglib:mmse_update_gpc_basic', 'gpc no variance reduction');
end
