function [xn, wn] = shift_quad_interval(In, x, w, varargin)
% SHIFT_QUAD_INTERVAL Shifts the quadrature rule to a new interval.
%   [XN, WN] = SHIFT_QUAD_INTERVAL(IN, X, W) shifts the quadrature rule
%   with nodes X and weights W defined on [-1, 1] to the new nodex XN and
%   WN defined on the new interval IN. If the source 
%
% Options
%   'I': [-1, 1]
%      Specify the source interval, if not equal to [-1, 1].
%
% Example (<a href="matlab:run_example shift_quad_interval">run</a>)
%   % Shift the trapezoidal rule the interval [2, 3]
%   [x, w] = trapezoidal_rule(5);
%   [xn, wn] = shift_quad_interval([2, 3], x, w);
%
% See also TRAPEZOIDAL_RULE, NEWTON_COTES_RULE

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

options=varargin2options(varargin, mfilename);
[I, options]=get_option(options, 'I', [-1, 1]);
check_unsupported_options(options, mfilename);

if all(I==In)
    xn = x;
    wn = w;
else
    a = I(1);
    b = I(2);
    c = In(1);
    d = In(2);
    wn = w * (d - c) / (b - a);
    xn = (x - a) * (d - c) / (b - a) + c;
end
