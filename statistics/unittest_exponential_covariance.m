function unittest_exponential_covariance
% UNITTEST_EXPONENTIAL_COVARIANCE Test the EXPONENTIAL_COVARIANCE function.
%
% Example (<a href="matlab:run_example unittest_exponential_covariance">run</a>)
%    unittest_exponential_covariance
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'exponential_covariance' );

assert_equals( exponential_covariance( 0, 1, 1, 2 ), 4*exp(-1), 'scalar_1d' );
assert_equals( exponential_covariance( 0, 1, 1, 0.5 ), 0.25*exp(-1), 'scalar_1d' );
assert_equals( exponential_covariance( 2, 0, 1, 2 ), 4*exp(-2), 'scalar_1d' );
assert_equals( exponential_covariance( 12, 10, 1, 2 ), 4*exp(-2), 'scalar_1d' );
assert_equals( exponential_covariance( 2*pi, 0, pi, 2 ), 4*exp(-2), 'scalar_1d' );
assert_equals( exponential_covariance( 0, 0, 1, 2 ), 4, 'scalar_1d' );
assert_equals( exponential_covariance( 0, [], 1, 2 ), 4, 'scalar_1d' );
assert_equals( exponential_covariance( 3, [], 2, 1 ), exp(-1.5), 'scalar_1d' );

assert_equals( exponential_covariance( [1; 2], [2; 3], 1, 2 ), 4*exp(-sqrt(2)), 'scalar_2d_iso' );
assert_equals( exponential_covariance( [1; 2], [2; 4], [1 2], 2 ), 4*exp(-sqrt(2)), 'scalar_2d_non' );
assert_equals( exponential_covariance( [1; 2; 3], [2; 3; 4], 1, 2 ), 4*exp(-sqrt(3)), 'scalar_3d_iso' );
assert_equals( exponential_covariance( [1; 2; 3], [2; 7; 12], [1 5 3], 2 ), 4*exp(-sqrt(11)), 'scalar_3d_non' );

assert_equals( exponential_covariance( [1 2; 3 5], [2 3; 4 7], 1, 2 ), 4*exp(-sqrt([2,5])), 'vector_2d_iso' );
assert_equals( exponential_covariance( [1 2; 3 5], [2 3; 4 7], [1 0.5], 2 ), 4*exp(-sqrt([5,17])), 'vector_2d_non' );
assert_equals( exponential_covariance( [1 3 1; 2 5 2], [2 4 3; 3 7 4], 1, 2 ), 4*exp(-sqrt([2,5,8])), 'vector_2d_iso' );
assert_equals( exponential_covariance( [1 3 1; 2 5 2], [2 4 3; 3 7 4], [1 0.5], 2 ), 4*exp(-sqrt([5,17,20])), 'vector_2d_non' );
assert_equals( exponential_covariance( [1 1 1; 2 1 1; 3 1 1], [2 2 3; 3 3 4; 4 4 5], 1, 2 ), 4*exp(-sqrt([3,14,29])), 'vector_3d_iso' );
assert_equals( exponential_covariance( [1 1 1; 2 1 1; 3 1 1], [2 2 3; 3 3 4; 4 4 5], [1 0.5 0.25]*10, 2 ), 4*exp(-sqrt([21,161,296])/10), 'vector_3d_non' );


munit_set_function( 'exponential_covariance' );
x=linspace(0,1,10);
assert_equals( exponential_covariance(x), exp(-x), 'simple' );
assert_equals( exponential_covariance(zeros(size(x)), x), exp(-x), 'simple' );
assert_equals( exponential_covariance(x,x), ones(size(x)), 'simple2' );
assert_equals( exponential_covariance(x'), exp(-norm(x)), 'simple3' );
assert_equals( exponential_covariance([x;x],[x;x]), ones(size(x)), 'simple3' );


