function [x,w]=trapezoidal_rule(n, varargin)
% TRAPEZOIDAL_RULE Compute points and weights of the trapezoidal rule.
%   [X,W]=TRAPEZOIDAL_RULE(N) computes the points and weights of the
%   composite trapezoidal rule with N+1 integration points (i.e. on N
%   subintervals), returning the points in the 1 x N+1 array X and the
%   weights in the N+1 x 1 array w.
%
% Options
%   'interval': [-1, 1]
%      Must be a double array of length 2, specifying the interval on which
%      the trapezoidal rule is to be computed.
%
% Example (<a href="matlab:run_example trapezoidal_rule">run</a>)
%   [x,w] = trapezoidal_rule(20);
%   fprintf('Integral of cosine from -1 to 1:\n');
%   fprintf('I_ex      = %g\n', sin(1) - sin(-1))
%   fprintf('I_trap_20 = %g\n', cos(x) * w)
%   fprintf('I_matlab  = %g\n', quad(@cos, -1, 1))
%
% See also INTEGRATE_1D, GAUSS_HERMITE_LEGENDRE_RULE, QUAD

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
[I,options]=get_option(options, 'interval', []);
check_unsupported_options(options);


x = linspace(-1, 1, n+1);
w0 = 1.0 / n * ones(n, 1);
w = [0;w0] + [w0;0];

if ~isempty(I)
    [x, w] = shift_quad_interval(I, x, w);
end
