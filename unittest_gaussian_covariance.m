function test_gaussian_covariance
% TEST_GAUSSIAN_COVARIANCE Test gaussian_covariance functions.
%
% Example (<a href="matlab:run_example test_gaussian_covariance">run</a>) 
%    test_gaussian_covariance
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'gaussian_covariance' );

assert_equals( gaussian_covariance( 0, 1, 1, 2 ), 4*exp(-1), 'scalar_1d' );
assert_equals( gaussian_covariance( 0, 1, 1, 0.5 ), 0.25*exp(-1), 'scalar_1d' );
assert_equals( gaussian_covariance( 2, 0, 1, 2 ), 4*exp(-4), 'scalar_1d' );
assert_equals( gaussian_covariance( 12, 10, 1, 2 ), 4*exp(-4), 'scalar_1d' );
assert_equals( gaussian_covariance( 2*pi, 0, pi, 2 ), 4*exp(-4), 'scalar_1d' );
assert_equals( gaussian_covariance( 0, 0, 1, 2 ), 4, 'scalar_1d' );
assert_equals( gaussian_covariance( 0, [], 1, 2 ), 4, 'scalar_1d' );
assert_equals( gaussian_covariance( sqrt(2), [], 2, 1 ), exp(-0.5), 'scalar_1d' );

assert_equals( gaussian_covariance( [1 2], [2 3], 1, 2 ), 4*exp(-2), 'scalar_2d_iso' );
assert_equals( gaussian_covariance( [1 2], [2 4], [1 2], 2 ), 4*exp(-2), 'scalar_2d_non' );
assert_equals( gaussian_covariance( [1 2 3], [2 3 4], 1, 2 ), 4*exp(-3), 'scalar_3d_iso' );
assert_equals( gaussian_covariance( [1 2 3], [2 7 12], [1 5 3], 2 ), 4*exp(-11), 'scalar_3d_non' );

assert_equals( gaussian_covariance( [1 2; 3 5], [2 3;4 7], 1, 2 ), 4*exp(-[2;5]), 'vector_2d_iso' );
assert_equals( gaussian_covariance( [1 2; 3 5], [2 3;4 7], [1 0.5], 2 ), 4*exp(-[5;17]), 'vector_2d_non' );
assert_equals( gaussian_covariance( [1 2; 3 5; 1 2], [2 3;4 7; 3 4], 1, 2 ), 4*exp(-[2;5;8]), 'vector_2d_iso' );
assert_equals( gaussian_covariance( [1 2; 3 5; 1 2], [2 3;4 7; 3 4], [1 0.5], 2 ), 4*exp(-[5;17;20]), 'vector_2d_non' );
assert_equals( gaussian_covariance( [1 2 3;1 1 1;1 1 1], [2 3 4;2 3 4;3 4 1], 1, 2 ), 4*exp(-[3;14;13]), 'vector_3d_iso' );
assert_equals( gaussian_covariance( [1 2 3;1 1 1;1 1 1], [2 3 4;2 3 4;3 4 5], [1 0.5 0.25]*10, 2 ), 4*exp(-[21;161;296]/100), 'vector_3d_non' );
