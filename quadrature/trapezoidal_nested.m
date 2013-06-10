function [x,w] = trapezoidal_nested(n)
% TRAPEZOIDAL_NESTED Computes the nested trapezoidal rule.
%   [X,W] = TRAPEZOIDAL_NESTED(N) computes the trapezoidal rule on 2^(M-1)
%   intervals. If [X1,W1] = TRAPEZOIDAL_NESTED(N+1) then X is always a
%   proper subset of X1. This rule is mostly useful for sparse grid
%   integration if the integrand is not very smooth.
%
% Example (<a href="matlab:run_example trapezoidal_nested">run</a>)
%   clf; hold all
%   for i = 1:5
%     [x, w] = trapezoidal_nested(i);
%     plot(x, i*ones(size(x)), 'x');
%   end
%   xlim([-1.3, 1.3]); ylim([0.5, 5.5])
%
% See also TRAPEZOIDAL_RULE, SMOLYAK_GRID, INTEGRATE_ND

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

[x, w] = trapezoidal_rule(2^(n-1));
