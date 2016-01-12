function [u, iter, res, model] = general_iterative_solver(model, p, varargin)
% GENERAL_ITERATIVE_SOLVER Solves a nonlinear system iteratively by using a given step function.
%   GENERAL_ITERATIVE_SOLVER solves a nonlinear system of equations
%   iteratively. The parameter STEP_FUNC specifies a function handle
%   that computes the a solver step and the residual for a given approximate
%   solution U. Internal model that is needed by RESIDUAL_FUNC can be
%   stored in MODEL. MODEL should also contain a start value U0, i.e. the
%   starting value for U will be MODEL.U0 is not specified otherwise. P
%   specifies a parameter vector that is also passed to RESIDUAL_FUNC.
%  
%   Options:
%       u0: start vector [model.u0]
%       maxiter: maximum number of iterations [100]
%       abstol: absolute stopping tolerance for the residual norm [1e-6]
%       steptol: minimum difference between iterates [1e-8]
%       verbosity: display convergence information if larger zero [0]
%
% Example (<a href="matlab:run_example nonlinear_solve_picard">run</a>)
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



options = varargin2options(varargin);
[u0, options] = get_option(options, 'u0', []);
[maxiter, options] = get_option(options, 'maxiter', 100);
[abstol, options] = get_option(options, 'abstol', 1e-6);
[steptol, options] = get_option(options, 'steptol', 1e-8);
[verbosity, options] = get_option(options, 'verbosity', 0);
check_unsupported_options(options, mfilename);

if isempty(u0)
    u = funcall(model.model_info.sol_init_func, p);
else
    u = u0;
end
for iter = 1:maxiter
    if any(isnan(u))
        keyboard;
    end
    [res, model] = spmodel_residual(model, u, p);
    res_norm = norm(res);
    if verbosity>0
        fprintf( 'nonlin_solve: iter %d, norm=%g\n', iter, res_norm);
    end
    if res_norm<abstol
        break;
    elseif iter==maxiter
        warning('solve:no_conv', ...
            'Could not reach convergence (abstol=%g) in %d iterations', ...
            abstol, maxiter);
    end
    
    u_old = u;
    [u, model] = spmodel_step(model, u, p);
    if norm(u-u_old, inf)<steptol
        break;
    end
end
