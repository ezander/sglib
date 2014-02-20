function unittest_mean_var_update
% UNITTEST_MEAN_VAR_UPDATE Test the MEAN_VAR_UPDATE function.
%
% Example (<a href="matlab:run_example unittest_mean_var_update">run</a>)
%   unittest_mean_var_update
%
% See also MEAN_VAR_UPDATE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'mean_var_update' );

% basic test with mean and variance
x = [5, 6, 11, 12, 12, 15, 3, 2];
[x_mean, x_var] = mean_var_update(1, x(1));
assert_equals( x_mean, mean(x(1:1)), 'mean1');
assert_equals( x_var, var(x(1:1)), 'var1');
[x_mean, x_var] = mean_var_update(2, x(2), x_mean, x_var);
assert_equals( x_mean, mean(x(1:2)), 'mean2');
assert_equals( x_var, var(x(1:2)), 'var2');
for n=3:length(x)
    [x_mean, x_var] = mean_var_update(n, x(n), x_mean, x_var);
end
assert_equals( x_mean, mean(x), 'mean_n');
assert_equals( x_var, var(x), 'var_n');


% test with only the mean
x = [3, 6, 10, 12, 12, 15, 3, 2, 6];
x_mean = 0;
for n=1:length(x)
    x_mean = mean_var_update(n, x(n), x_mean);
end
assert_equals( x_mean, mean(x), 'only_mean');


% m-dimensional vector 
N = 100;
m = 10;
x = rand(m, N);
x_mean = [];
x_var = [];
for n=1:N
    [x_mean, x_var] = mean_var_update(n, x(:,n), x_mean, x_var);
end
assert_equals( x_mean, mean(x,2), 'md_mean');
assert_equals( x_var, var(x,[],2), 'md_var');

x_mean = [];
x_var = [];
x_m2 = [];
for n=1:N
    [x_mean, x_var, x_m2] = mean_var_update(n, x(:,n), x_mean, x_var, x_m2);
end
assert_equals( x_mean, mean(x,2), 'md2_mean');
assert_equals( x_var, var(x,[],2), 'md2_var');



