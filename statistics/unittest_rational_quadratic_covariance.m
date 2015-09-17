function unittest_rational_quadratic_covariance
% UNITTEST_RATIONAL_QUADRATIC_COVARIANCE Test the RATIONAL_QUADRATIC_COVARIANCE function.
%
% Example (<a href="matlab:run_example unittest_rational_quadratic_covariance">run</a>)
%   unittest_rational_quadratic_covariance
%
% See also RATIONAL_QUADRATIC_COVARIANCE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'rational_quadratic_covariance' );

x=linspace(0,1,10);
assert_equals( rational_quadratic_covariance(1, x), 1./(1+x.^2/2), 'simple');

assert_equals( rational_quadratic_covariance(1, x, [], 3), 1./(1+(x/3).^2/2), 'scale_l');

assert_equals( rational_quadratic_covariance(1, x, [], 1, 5), 25./(1+x.^2/2), 'scale_s');


