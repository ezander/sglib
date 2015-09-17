function unittest_line_search_armijo
% UNITTEST_LINE_SEARCH_ARMIJO Test the LINE_SEARCH_ARMIJO function.
%
% Example (<a href="matlab:run_example unittest_line_search_armijo">run</a>)
%   unittest_line_search_armijo
%
% See also LINE_SEARCH_ARMIJO, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'line_search_armijo' );

% Some experiments with the sine function starting at pi/2 and direction
% p=2*pi, for which the expected outcomes are quite simple and clear to
% predict
f_func=@sin; df_func=@cos;
func=func_combine_f_df(f_func, df_func);
x = pi/2+0.2;
p = 2*pi;
[y, dy] = funcall(func, x);
[alpha, xn, yn, dyn] = line_search_armijo(func, x, p, y, dy);
assert_true(yn<y + alpha * p * dy, 'armijo cond', 'armijo')
assert_equals(alpha, 0.5, 'alpha_ex')
assert_equals(xn, x+alpha*p, 'xn');
assert_equals(yn, funcall(f_func, xn), 'yn');
assert_equals(dyn, funcall(df_func, xn), 'dyn');

alpha = line_search_armijo(func, x, p, y, dy, 'alpha0', 4);
assert_equals(alpha, 0.5, 'alpha_ex')

alpha = line_search_armijo(func, x, p, y, dy, 'rho', 0.3);
assert_equals(alpha, 0.3, 'alpha_ex')

alpha = line_search_armijo(func, x, p, y, dy, 'alpha0', 4, 'rho', 0.25);
assert_equals(alpha, 0.25, 'alpha_ex')

% Now with a disguised sine function
f_func=@(x)(sin(x(2)) + x(1) - 2*x(3)); 
df_func=@(x)([1, cos(x(2)), -2]);
func=func_combine_f_df(f_func, df_func);
x = [2; pi/2+0.2; 5];
p = [0; 2*pi; 0];
[y, dy] = funcall(func, x);
[alpha, xn, yn, dyn] = line_search_armijo(func, x, p, y, dy);
assert_true(yn<y + alpha * p * dy, 'armijo cond', 'armijo')
assert_equals(alpha, 0.5, 'alpha_ex')
assert_equals(xn, x+alpha*p, 'xn');
assert_equals(yn, funcall(f_func, xn), 'yn');
assert_equals(dyn, funcall(df_func, xn), 'dyn');


% Now with a function that starts at 1 for x=0, then has a minimum and goes
% again to 1 for x->infty
k = 3;
f_func = @(x)((exp(-(x/k).^2)) + (atan(x/k)*2/pi).^2);
df_func = @(x)(-2*x/k^2.*exp(-(x/k).^2) + 4/pi/k./(1+(x/k).^2).*(atan(x/k)*2/pi)); 
func = func_combine_f_df(f_func, df_func);

x = 2;
p = 20;
alpha0 = 100;
[alpha, ~, yn] = line_search_armijo(func, x, p, [], [], 'alpha0', alpha0);
assert_true(yn<y + alpha * p * dy, 'armijo cond', 'armijo')

% alpha should not be reduced if it already fulfill the conditions
alpha2 = line_search_armijo(func, x, p, [], [], 'alpha0', alpha);
assert_equals(alpha2, alpha, 'no change')

% check that verbose output is ok
assert_output(funcreate(@line_search_armijo,func, x, p, [], [], 'alpha0', alpha, 'verbosity', 1), ...
    'armijo line search: iter=1, alpha=0.390625, yn=0.657922, yn_max=0.78117\n');
