function unittest_pairwise_distance(varargin)
% UNITTEST_PAIRWISE_DISTANCE Test the PAIRWISE_DISTANCE function.
%
% Example (<a href="matlab:run_example unittest_pairwise_distance">run</a>)
%   unittest_pairwise_distance
%
% See also PAIRWISE_DISTANCE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2018, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'pairwise_distance' );


N = 7;
pos = rand(3, N);
d = pairwise_distance(pos);
assert_equals(diag(d), zeros(N,1), 'diag is 0');
assert_matrix(d, 'symmetric', 'symmetry');
assert_equals(d(2,3), norm(pos(:,2)-pos(:,3), 2), 'dist1');
assert_equals(d(5,7), norm(pos(:,5)-pos(:,7), 2), 'dist2');

d = pairwise_distance(pos, 'norm', 1);
assert_equals(d(2,3), norm(pos(:,2)-pos(:,3), 1), 'dist3');
assert_equals(d(5,7), norm(pos(:,5)-pos(:,7), 1), 'dist4');

pos1 = rand(3, 5);
pos2 = rand(3, 7);
d = pairwise_distance(pos1, pos2, 'norm', inf);
assert_equals(d(2,3), norm(pos1(:,2)-pos2(:,3), inf), 'dist5');
