function [u_i_alpha,x,w]=compute_response_surface_nonintrusive_galerkin(init_func, step_func, V_u, p_int, varargin)
% COMPUTE_RESPONSE_SURFACE_NONINTRUSIVE_GALERKIN Short description of compute_response_surface_nonintrusive_galerkin.
%   COMPUTE_RESPONSE_SURFACE_NONINTRUSIVE_GALERKIN Long description of compute_response_surface_nonintrusive_galerkin.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example compute_response_surface_nonintrusive_galerkin">run</a>)
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
[solve_func, options]=get_option(options, 'solve_func', []);
[p_int_proj, options]=get_option(options, 'p_int_proj', []);
[u0_i_alpha, options]=get_option(options, 'u0_i_alpha', []);
[max_iter, options]=get_option(options, 'max_iter', 50);
[threshold, options]=get_option(options, 'threshold', 1e-5);
[grid, options]=get_option(options, 'grid', 'smolyak');
check_unsupported_options(options, mfilename);

state = funcall(init_func);

if ~isempty(u0_i_alpha)
    u_i_alpha = u0_i_alpha;
elseif ~isempty(p_int_proj)
    u_i_alpha = compute_response_surface_projection(init_func, solve_func, V_u, p_int_proj, 'grid', 'smolyak');
else
    u_i_alpha = repmat(state.u0, 1, gpcbasis_size(V_u,1));
end


[x,w] = gpc_integrate([], V_u, p_int, 'grid', grid);
Q = length(w);

converged=false;
for k=1:max_iter
    unext_i_alpha = u_i_alpha;
    % do the computation of unext
    
    % that's the z-sum here, i.e. z=x(:,j)
    for j=1:Q
        p = x(:, j);
        % compute u_i_p = sum u_i_alpha Psi_alpha(p)
        u_i_p = gpc_evaluate(u_i_alpha, V_u, p);
        % evaluate S at p, u_i_p
        S_p = funcall(step_func, state, u_i_p, p);
        % update unext
        unext_i_alpha = unext_i_alpha + w(j) * S_p * gpcbasis_evaluate(V_u, p, 'dual', true);
    end
    
    % compute the size of the update step in the Frobenius norm, maybe not
    % the best convergence criterion, but at least easy and fast to compute
    diff=norm(u_i_alpha-unext_i_alpha,'fro');
    u_i_alpha = unext_i_alpha;
    
    % print 
    strvarexpand('iter: $k$, diff: $diff$');

    % check for convergence
    if diff<threshold
        converged = true;
        break;
    end
    
    % 
    if ~isfinite(diff) || isnan(diff)
        break
    end
end

if ~converged
    error('sglib:non_intr_galerkin', 'The Galerkin iteration did not converge');
end

