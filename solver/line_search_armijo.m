function [alpha, xn, yn, dyn, flag]=line_search_armijo(func, x, p, y, dy, varargin)
% LINE_SEARCH_ARMIJO Performs a backtracking Armijo line search.
%   [ALPHA,XN,YN,DYN,FLAG]=LINE_SEARCH_ARMIJO(FUNC,X,P,Y,DY,OPTIONS)
%   performs a backtracking line search until the Armijo condition for
%   sufficient decrease (f(x+alpha*p)<=f(x)+alpha*c1*f'(x)*p) is fulfilled.
%   FUNC is the function to be optimised and should return the function
%   value as first output argument and the derivative as second output
%   argument. X is the starting point, P is the search direction, Y is the
%   function value at X, but can also be empty. DY is the value of the
%   derivative at X or can be empty.
%
%   The algorithm works by starting with an initial ALPHA0 and then
%   reducing it in each iteration by a constant factor 0<RHO<1 until the
%   Armijo condition is fulfilled (see [1], procedure 3.1, page 41f).
%
% Options:
%   alpha0: double {1}
%     Initial value for alpha.
%   rho: double {0.5}
%     Reduction factor for alpha.
%   c: double {1e-4}
%     Constant in the Armijo condition.
%   maxiter: integer {100}
%     Maximum number of iterations until suitable alpha is found.
%   verbosity: integer {0}
%     If larger zero diagnoistic messages will be printed.
%   
% References
%   [1] Nocedal, J. and Wright, S.J. (1999): Numerical Optimization,
%       Springer-Verlag. ISBN 0-387-98793-2.
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

options=varargin2options(varargin,mfilename);
[alpha0, options]=get_option(options,'alpha0',1);
[rho, options]=get_option(options,'rho',0.5);
[c, options]=get_option(options,'c',1e-4);
[maxiter, options]=get_option(options,'maxiter',100);
[stretch, options]=get_option(options,'stretch', false);
[verbosity, options]=get_option(options,'verbosity',0);
check_unsupported_options(options);

% compute f and grad(f) if not given
if isempty(y) || isempty(dy)
    [y, dy] = funcall(func, x);
end

flag = 1;
alpha = alpha0;
slope = c * tensor_scalar_product(dy, p);
for iter=1:maxiter
    xn = tensor_add(x, p, alpha);
    [yn, dyn] = funcall(func, xn);
    if verbosity>0
        strvarexpand('armijo line search: iter=$iter$, alpha=$alpha$, yn=$yn$, yn_max=$y + alpha * slope$');
    end
    if yn <= y + alpha * slope
        flag = 0;
        break;
    end
    alpha = rho * alpha;
end
if flag
    warning('sglib:line_search:armijo', 'Did not find sufficient decrease after %d iterations.', maxiter);
end

if ~stretch || alpha~=alpha0
    return
end

alphan=alpha;
for iter=1:maxiter
    alphan = alphan / rho;
    xnn = tensor_add(x, p, alphan);
    [ynn, dynn] = funcall(func, xnn);
    if verbosity>0
        strvarexpand('armijo line search: iter=$iter$, alpha=$alpha$, yn=$yn$, yn_max=$y + alpha * slope$');
    end
    if ynn > y + alphan * slope
        break;
    end
    alpha = alphan;
    xn = xnn;
    yn = ynn;
    dyn = dynn;
end
