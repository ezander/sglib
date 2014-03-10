function unittest_fzero_ridders
% UNITTEST_FZERO_RIDDERS Test the FZERO_RIDDERS function.
%
% Example (<a href="matlab:run_example unittest_fzero_ridders">run</a>)
%   unittest_fzero_ridders
%
% See also FZERO_RIDDERS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'fzero_ridders' );

% In text example from [1]
func = @(x)(x^3-x-5);
xa = -1; xb = 3;
[x,flag,info]=fzero_ridders(func, xa, xb, 'maxiter', 1);
assert_equals(x, 1.9128, 'ex_poly', 'abstol', 0.0001)
assert_equals(flag, 1, 'ex_poly_flag');
assert_equals(info.fval, funcall(func,x), 'ex_poly_fval');
assert_equals(info.gval, funcall(func,x), 'ex_poly_gval');

% Example Ia from [1]
func = @(x)(x*exp(x)-10);
xa = -10; xb = 10;
[x,flag]=fzero_ridders(func, xa, xb, 'maxiter', 6, 'abstol', 0, 'reltol', 0);
assert_equals(x, 1.745528003, 'ex_i', 'abstol', 1e-9, 'reltol', 0)
assert_equals(flag, 1, 'ex_i_flag');

% Example IIb from [1]
func = @(x)(tan(x)^tan(x)-1000);
xa = 0; xb = 1.5;
[x, flag]=fzero_ridders(func, xa, xb, 'maxiter', 8, 'abstol', 0, 'reltol', 0);
assert_equals(x, 1.354710442, 'ex_ii', 'abstol', 1e-9, 'reltol', 0)
assert_equals(flag, 1, 'ex_ii_flag');

% Combining Poly and III (sin)
func = @(x)([x^3-x-5; sin(x*pi/1.8)]);
xa = 1.5; xb = 2.5;
r = ((45 - sqrt(2013))^(1/3) + (45 + sqrt(2013))^(1/3))/18^(1/3);
[x, flag]=fzero_ridders(func, xa, xb, 'd', [1,0], 'maxiter', 100, 'abstol', 1e-8, 'reltol', 1e-8);
assert_equals(x, r, 'ex_ii', 'abstol', 1e-9, 'reltol', 0)
assert_equals(flag, 0, 'ex_ii_flag');

x=fzero_ridders(func, xa, xb, 'd', [0,1], 'maxiter', 100, 'abstol', 1e-8, 'reltol', 1e-8);
assert_equals(x, 1.8, 'ex_ii', 'abstol', 1e-9, 'reltol', 0)

