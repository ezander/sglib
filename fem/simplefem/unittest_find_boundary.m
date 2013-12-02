function unittest_find_boundary
% UNITTEST_FIND_BOUNDARY Test the FIND_BOUNDARY function.
%
% Example (<a href="matlab:run_example unittest_find_boundary">run</a>)
%   unittest_find_boundary
%
% See also FIND_BOUNDARY

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'find_boundary' );

[pos,els]=create_mesh_1d( 0, 2, 5);
swallow(pos);
assert_equals( find_boundary( els ), [1,5], '1d' );

% 2D test for the following grid
%  1
% 234
%  5
els=[1 2 3; 1 3 4; 2 3 5; 3 4 5]';
assert_equals( find_boundary( els, true ), [1,2,4,5], '2d_points' );
assert_equals( find_boundary( els, false ), [1 2;1 4;2 5; 4 5]', '2d_els' );

% shuffle stuff a bit
els=els([2,1,3],[3,4,1,2]);
assert_equals( find_boundary( els, true ), [1,2,4,5], '2d2_points' );
assert_equals( find_boundary( els, false ), [1 2;1 4;2 5; 4 5]', '2d2_els' );

assert_error( 'find_boundary([1 2 3 4])', 'simplefem:find_boundary', 'wrong_dimen' );
