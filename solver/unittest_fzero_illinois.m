function unittest_fzero_illinois
% UNITTEST_FZERO_ILLINOIS Test the FZERO_ILLINOIS function.
%
% Example (<a href="matlab:run_example unittest_fzero_illinois">run</a>)
%   unittest_fzero_illinois
%
% See also FZERO_ILLINOIS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'fzero_illinois' );

%% Simple test with illinois, bisection, regula falsi
func = @(x)(cos(x)-0.8);
xa = 0;
xb = pi/2;
[x, flag, info]=fzero_illinois(func, xa, xb);
assert_equals(flag, 0);
assert_equals(x, acos(0.8));
assert_equals(info.fval, 0);
assert_equals(info.gval, 0);
assert_true(info.iter<=6, 'maximum 6 iterations');

[x, flag, info]=fzero_illinois(func, xa, xb, 'bisect', true);
assert_equals(flag, 0);
assert_equals(x, acos(0.8));
assert_equals(info.fval, 0);
assert_equals(info.gval, 0);
assert_true(info.iter<=24);

[x, flag, info]=fzero_illinois(func, xa, xb, 'illinois', false);
assert_equals(flag, 0);
assert_equals(x, acos(0.8));
assert_equals(info.fval, 0);
assert_equals(info.gval, 0);
assert_true(info.iter<=16);


%%
func2 = @(x)([cos(x)-0.8; cos(x)-0.7]);
xa = 0;
xb = pi/2;
[x,flag,info]=fzero_illinois(func2, xa, xb, 'maxiter', 100, 'd', [1,0]);
assert_equals(x, acos(0.8));
assert_equals(flag, 0);
assert_equals(info.fval, 0);
assert_equals(info.gval, [0; 0.1]);
[x,flag,info]=fzero_illinois(func2, xa, xb, 'maxiter', 100, 'd', [0,1]);
assert_equals(x, acos(0.7));
assert_equals(flag, 0);
assert_equals(info.fval, 0);
assert_equals(info.gval, [-0.1;0]);

