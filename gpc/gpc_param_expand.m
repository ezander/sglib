function [a_alpha, V_a, varerr] = gpc_param_expand(a_dist, sys, varargin)
% GPC_PARAM_EXPAND Computes GPC expansion of an input parameter.
%   [A_ALPHA,V_A,VARERR]=GPC_PARAM_EXPAND(A_DIST, SYS, OPTIONS) computes
%   the GPC expansion of the parameter A (input parameter for a stochastic
%   model or whatever) with GPC coefficient returned in A_ALPHA and the GPC
%   basis returned in V_A. With no options specified the degree of the
%   expansion is automatically determined, such that the error in variance
%   is smaller than 0.01. The actual error in variance is returned in
%   VARERR.
%
% Notes
%   Some target distributions can be really tricky, by having e.g. sharp
%   singularities, high variances relative to the mean, etc. It is not
%   guaranteed then the GPC_PARAM_EXPAND returns sensible results. You will
%   probably need to experiment with the polynomial system for the germ,
%   the expansion degree and the degree of the integration rule yourself,
%   until the PDFs (or whatever is of interest) match sufficiently.
%
% Options
%   'p': integer
%      If set the degree of the expansion is set to P. Otherwise, P is
%      determined such that the error in variance is smaller then VARERR.
%   'p_int': integer
%      Degree of integration rule used. If unset (default), this is
%      determined automatically with respect to the degree of the
%      expansion.
%   'varerr': 0.01
%      Absolute error in variance
%   'fixvar': {false}, true
%      Scale the GPC coefficients at the end to match the variance of
%      A_DIST exactly. VARERR is then always zero.
%
% Example (<a href="matlab:run_example gpc_param_expand">run</a>)
%
% See also GPCBASIS_CREATE, GPC_MOMENTS, GPC_PDF_1D, GPC_CDF_1D

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
[p,options]=get_option(options,'p', @default);
[p_int,options]=get_option(options,'p_int', @default);
[varerr,options]=get_option(options,'varerr', 0.01);
[fixvar,options]=get_option(options,'fixvar', false);
check_unsupported_options(options,mfilename);

check_type(sys, 'char', false, 'sys', mfilename);
check_range(length(sys), 1, 1, 'length(sys)', mfilename); 

[a_mean, a_var] = gendist_moments(a_dist);
if isequal(p,@default)
    for p=0:50
        V_a = gpcbasis_create(sys, 'p', p);
        if isequal(p_int,@default)
            p_int = max(10, p);
        end
        a_alpha = do_param_expand(a_dist, V_a, p_int);
        a_var_gpc = gpc_moments(a_alpha, V_a, 'var_only', true);
        if abs(a_var-a_var_gpc)<varerr*a_var
            break;
        end
    end
    if abs(a_var-a_var_gpc)>=varerr*a_var
        diststr=strvarexpand('$a_dist{1}$$a_dist{2}$');
        error('sglib:gpc_param_expand', 'Could not reach target variance %g error in GPC parameter expansion of %s', varerr, diststr);
    end
else
    if isequal(p_int,@default)
        p_int = max(10, p);
    end
    V_a = gpcbasis_create(sys, 'p', p);
    a_alpha = do_param_expand(a_dist, V_a, p_int);
end
if ~all(isfinite(a_alpha))
    expl =['This may happen, if the integration rule selected point for which due ', ...
        'to numerical accuracy the CDF of the germ returns 1 and the inverse ', ...
        'CDF of the target distribution returns INF.'];
    error('sglib:gpc_param_expand', 'Problem in gpc_param_expand. You probably need to limit the degree of the integration rule by setting the "p_int" option.\n\n%s', expl);
end

% Replace the first gpc coefficient with the true mean
a_alpha(1) = a_mean;

% Compute the variance error or rescale the coefficients to fit the true
% variance if requested (in which case the varerror is of course zero)
a_var_gpc = gpc_moments(a_alpha, V_a, 'var_only', true);
if fixvar
    a_alpha(2:end) = a_alpha(2:end) * sqrt(a_var/a_var_gpc);
    varerr = 0;
else
    varerr = abs(a_var - a_var_gpc);
end

function a_alpha = do_param_expand(a_dist, V, p_int)
[x,w]=gpc_integrate([], V, p_int);
psi_k_alpha = gpcbasis_evaluate(V, x, 'dual', true);
fun_k = gendist_invcdf(gpcgerm_cdf(V, x), a_dist);
a_alpha = fun_k*diag(w)*psi_k_alpha;
