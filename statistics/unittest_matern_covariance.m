function unittest_matern_covariance
% UNITTEST_MATERN_COVARIANCE Test the MATERN_COVARIANCE function.
%
% Example (<a href="matlab:run_example unittest_matern_covariance">run</a>)
%   unittest_matern_covariance
%
% See also MATERN_COVARIANCE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'matern_covariance' );


%% Special cases

% a) nu very large (limit to infty) should be same as Gaussian 
x=linspace(0,1,10);
assert_equals( matern_covariance(100, x), exp(-x.^2/2), 'simple', 'abstol', 0.01 );

%) b) nu=1/2 exponential
x=linspace(0,10);
assert_equals( matern_covariance(0.5, x, []), exp(-x), '0.5/exp')

%) c) nu=3/2 and nu=5/2 (see 4.17 in Ref. [2] in matern_covariance.m)
x=linspace(0,10);
assert_equals( matern_covariance(1.5, x, []), (1+sqrt(3)*x).*exp(-sqrt(3)*x), 'nu1.5')
assert_equals( matern_covariance(2.5, x, []), (1+sqrt(5)*x+5/3*x.^2).*exp(-sqrt(5)*x), 'nu1.5')

%% Test scaling
x=linspace(0,10);
assert_equals( matern_covariance(0.5, x, [], 3), exp(-x/3), 'l')
assert_equals( matern_covariance(0.5, x, [], 3, 4), 16*exp(-x/3), 'l_sig')

%% test the accuracy around 0
d = 1e-10;
x=linspace(0,d,30);
assert_equals( (matern_covariance(0.5, x, [])-1)/d, expm1(-x)/d, 'around0', 'reltol', 1e-4)



