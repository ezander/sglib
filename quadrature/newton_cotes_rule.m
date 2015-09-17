function [x,w]=newton_cotes_rule(n, varargin)
% NEWTON_COTES_RULE Compute points and weights of the trapezoidal rule.
%   [X,W]=NEWTON_COTES_RULE(N) computes the points and weights of the
%   closed Newton-Cotes rule with N+1 integration points returning the
%   points in the 1 x N+1 array X and the weights in the N+1 x 1 array w.
%
%   [X,W]=NEWTON_COTES_RULE(N, 'open', TRUE) computes the points and
%   weights of the open Newton-Cotes rule with N-1 integration points
%   returning the points in the 1 x N-1 array X and the weights in the N-1
%   x 1 array w.
%
% Options
%   'open': {false}, true
%      If set to true, the open Newton-Cotes rule is used.
%   'interval': [-1, 1]
%      Must be a double array of length 2, specifying the interval on which
%      the Newton-Cotes rule is to be computed.
%
% References
%   [1] Germund Dalquist, Åke Björck: "Numerical Methods in Scientific
%       Computing, Volume 1", SIAM,
%       http://www.siam.org/books/ot103/OT103%20Dahlquist%20Chapter%205.pdf 
%   [2] https://en.wikipedia.org/wiki/Newton-Cotes_formulas
%
% Example (<a href="matlab:run_example newton_cotes_rule">run</a>)
%   % Compare exact integration, NewtonCotes 5, NC20, and matlab's quad function
%   [x5,w5] = newton_cotes_rule(5);
%   [x20,w20] = newton_cotes_rule(20);
%   fprintf('Integral of cosine from -1 to 1:\n');
%   fprintf('I_ex     = %10.8f\n', sin(1) - sin(-1));
%   fprintf('I_nc5    = %10.8f\n', cos(x5) * w5);
%   fprintf('I_nc20   = %10.8f\n', cos(x20) * w20);
%   fprintf('I_matlab = %10.8f\n', quad(@cos, -1, 1));
%
% See also INTEGRATE_1D, GAUSS_LEGENDRE_RULE, TRAPEZOIDAL_RULE

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

options=varargin2options(varargin, mfilename);
[open,options]=get_option(options, 'open', false);
[I,options]=get_option(options, 'interval', []);
check_unsupported_options(options);

if ~open
    x = linspace(-1, 1, n+1);
else
    x = linspace(-1, 1, n+1);
    x = x(2:end-1);
end
w = interpolatory_weights(x);

if ~isempty(I)
    [x, w] = shift_quad_interval(I, x, w);
end
