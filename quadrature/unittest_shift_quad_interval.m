function unittest_shift_quad_interval
% UNITTEST_SHIFT_QUAD_INTERVAL Test the SHIFT_QUAD_INTERVAL function.
%
% Example (<a href="matlab:run_example unittest_shift_quad_interval">run</a>)
%   unittest_shift_quad_interval
%
% See also SHIFT_QUAD_INTERVAL, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'shift_quad_interval' );


% Standard
N = 10;
x = linspace(-1, 1, N);
w = ones(1,N);
In = [4, 8];
[xn, wn] = shift_quad_interval(In, x, w);
assert_equals(xn, linspace(In(1), In(2), N), 'std_x');
assert_equals(wn, 2*w, 'std_w');

% With source interval
N = 13;
x = linspace(3, 5, N);
w = rand(1,N);
In = [-8, 2];
[xn, wn] = shift_quad_interval(In, x, w, 'I', [3, 5]);
assert_equals(xn, linspace(In(1), In(2), N), 'source_x');
assert_equals(wn, 5*w, 'source_w');

% No change
N = 17;
x = linspace(3, 5, N);
w = rand(1,N);
In = [3, 5];
[xn, wn] = shift_quad_interval(In, x, w, 'I', [3, 5]);
assert_equals(xn, x, 'nochange_x');
assert_equals(wn, w, 'nochange_w');
