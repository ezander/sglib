function [u, iter, res] = nonlinear_solve_picard(residual_func, state, p, varargin)
% NONLINEAR_SOLVE_PICARD Solve nonlinear system iteratively by a simple solver based on Picard iterations.
%   NONLINEAR_SOLVE_PICARD solves a nonlinear system of equations by Picard
%   iterations. The parameter RESIDUAL_FUNC specifies a function handle
%   that computes the preconditioned residual for a given approximate
%   solution U. Internal state that is needed by RESIDUAL_FUNC can be
%   stored in STATE. STATE should also contain a start value U0, i.e. the
%   starting value for U will be STATE.U0 is not specified otherwise. P
%   specifies a parameter vector that is also passed to RESIDUAL_FUNC.
%  
%   Options:
%       u0: start vector [state.u0]
%       max_iter: maximum number of iterations [100]
%       abstol: absolute stopping tolerance for the residual norm [1e-5]
%       verbose: display convergence information [false]
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
[u0, options] = get_option(options, 'u0', state.u0);
[max_iter, options] = get_option(options, 'max_iter', 100);
[abstol, options] = get_option(options, 'abstol', 1e-5);
[verbose, options] = get_option(options, 'verbose', false);
check_unsupported_options(options, mfilename);


u = u0;
for iter = 1:max_iter
    r = funcall(residual_func, state, u, p);
    res = norm(r);
    if verbose
        fprintf( 'nonlin_solve: iter %d, norm=%g\n', iter, res);
    end
    if norm(res)<abstol
        break;
    elseif iter==max_iter
        error('solve:no_conv', ...
            'Could not reach convergence (abstol=%g) in %d iterations', ...
            abstol, max_iter);
    end
    
    u = u + state.A \ r;
end
