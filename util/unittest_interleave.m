function unittest_interleave(varargin)
% UNITTEST_INTERLEAVE Test the INTERLEAVE function.
%
% Example (<a href="matlab:run_example unittest_interleave">run</a>)
%   unittest_interleave
%
% See also INTERLEAVE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2017, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'interleave' );

A = randi(100, 3,6,4);
B1 = randi(100, 2,6,4);
B2 = randi(100, 3,6,4);
B3 = randi(100, 3,5,4);

C=interleave(A,B1);
assert_equals(C(1:2:end,:,:), A, 't1_A');
assert_equals(C(2:2:end,:,:), B1, 't1_B');

C=interleave(A,B2,1);
assert_equals(C(1:2:end,:,:), A, 't21_A');
assert_equals(C(2:2:end,:,:), B2, 't21_B');
C=interleave(A,B2,2);
assert_equals(C(:,1:2:end,:), A, 't22_A');
assert_equals(C(:,2:2:end,:), B2, 't22_B');
C=interleave(A,B2,3);
assert_equals(C(:,:,1:2:end), A, 't23_A');
assert_equals(C(:,:,2:2:end), B2, 't23_B');

C=interleave(A,B3,2);
assert_equals(C(:,1:2:end,:), A, 't3_A');
assert_equals(C(:,2:2:end,:), B3, 't3_B');


