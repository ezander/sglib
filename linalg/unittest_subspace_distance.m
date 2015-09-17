function unittest_subspace_distance
% UNITTEST_SUBSPACE_DISTANCE Test the SUBSPACE_DISTANCE function.
%
% Example (<a href="matlab:run_example unittest_subspace_distance">run</a>)
%   unittest_subspace_distance
%
% See also SUBSPACE_DISTANCE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'subspace_distance' );

munit_control_rand('seed', 74765);

N=10;
A=rand(N,3);
B=rand(N,5);

assert_equals(subspace_distance(A,B), subspace_distance(B,A), 'symm');
assert_equals(subspace_distance(A,B), sin(subspace(A,B)), 'mlab');
assert_equals(subspace_distance(A,[B, A]), 0, 'zero');


opts.type = 'gv';
A=rand(N,3);
B=rand(N,3);
assert_equals(subspace_distance(A,B,opts), subspace_distance(B,A,opts), 'symm_gv');
assert_equals(subspace_distance(A,B,opts), subspace_distance(A,B), 'same_as_mlab_if_same_size');
assert_equals(subspace_distance(A,[B, A],opts), 1, 'one_gv');


opts.type = 'wwf';
A=rand(N,3);
B=rand(N,3);
assert_equals(subspace_distance(A,B,opts), subspace_distance(B,A,opts), 'symm_wwf');
assert_equals(subspace_distance(A, A, opts), 0, 'zero_wwf');


assert_error(funcreate(@subspace_distance,A,B,'type', 'qwerty'), 'sglib:', 'err_type');


