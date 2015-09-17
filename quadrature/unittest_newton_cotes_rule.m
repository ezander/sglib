function unittest_newton_cotes_rule
% UNITTEST_NEWTON_COTES_RULE Test the NEWTON_COTES_RULE function.
%
% Example (<a href="matlab:run_example unittest_newton_cotes_rule">run</a>)
%   unittest_newton_cotes_rule
%
% See also NEWTON_COTES_RULE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'newton_cotes_rule' );

%% Closed Newton-Cotes rules

% 1 - Trapezoid rule $\frac{1}{1} (f_0 + f_1)$
[x,w] = newton_cotes_rule(1);
x_ex = [-1, 1];
w_ex = [1, 1]';
assert_equals(x, x_ex, 'nc_closed_1_x');
assert_equals(w, w_ex, 'nc_closed_1_w');

% 2 - Simpson's rule $\frac{1}{3} (f_0 + 4 f_1 + f_2)$
[x,w] = newton_cotes_rule(2);
x_ex = [-1, 0, 1];
w_ex = [1, 4, 1]'/3;
assert_equals(x, x_ex, 'nc_closed_2_x');
assert_equals(w, w_ex, 'nc_closed_2_w');

% 3 - Simpson's 3/8 rule $\frac{1}{4} (f_0 + 3 f_1 + 3 f_2 + f_3)$
[x,w] = newton_cotes_rule(3);
x_ex = [-1, -1/3, 1/3, 1];
w_ex = [1, 3, 3, 1]'/4;
assert_equals(x, x_ex, 'nc_closed_3_x');
assert_equals(w, w_ex, 'nc_closed_3_w');

% 4 - Boole's rule $\frac{1}{45} (7 f_0 + 32 f_1 + 12 f_2 + 32 f_3 + 7 f_4)$
[x,w] = newton_cotes_rule(4);
x_ex = [-1, -1/2, 0, 1/2, 1];
w_ex = [7, 32, 12, 32, 7]'/45;
assert_equals(x, x_ex, 'nc_closed_4_x');
assert_equals(w, w_ex, 'nc_closed_4_w');


%% Open Newton-Cotes rules

% 2 - Midpoint rule $2 f_1$
[x,w] = newton_cotes_rule(2, 'open', true);
x_ex = [0]; %#ok<NBRAK>
w_ex = [2]'; %#ok<NBRAK>
assert_equals(x, x_ex, 'nc_open_2_x');
assert_equals(w, w_ex, 'nc_open_2_w');

% 3 - Trapezoid method $f_1 + f_2$
[x,w] = newton_cotes_rule(3, 'open', true);
x_ex = [-1/3, 1/3];
w_ex = [1, 1]';
assert_equals(x, x_ex, 'nc_open_3_x');
assert_equals(w, w_ex, 'nc_open_3_w');

% 4 - Milne's rule $\frac{2}{3} (2 f_1 - f_2 + 2 f_3)$
[x,w] = newton_cotes_rule(4, 'open', true);
x_ex = [-1/2, 0, 1/2];
w_ex = [2, -1, 2]'*2/3;
assert_equals(x, x_ex, 'nc_open_4_x');
assert_equals(w, w_ex, 'nc_open_4_w');

% 5 - No name $\frac{1}{12} (11 f_1 + f_2 + f_3 + 11 f_4)$
[x,w] = newton_cotes_rule(5, 'open', true);
x_ex = [-3, -1, 1, 3]/5;
w_ex = [11, 1, 1, 11]'/12;
assert_equals(x, x_ex, 'nc_open_5_x');
assert_equals(w, w_ex, 'nc_open_5_w');

%% Test the default (closed)

x1 = newton_cotes_rule(5);
x2 = newton_cotes_rule(5, 'open', false);
assert_equals(x1, x2, 'default_closed');

%% Test on different interval
[x,w] = newton_cotes_rule(1, 'interval', [2, 3]);
x_ex = [2, 3];
w_ex = [0.5, 0.5]';
assert_equals(x, x_ex, 'int_23_x');
assert_equals(w, w_ex, 'int_23_w');
