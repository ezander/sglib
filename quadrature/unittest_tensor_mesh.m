function unittest_tensor_mesh
% UNITTEST_TENSOR_MESH Test the TENSOR_MESH function.
%
% Example (<a href="matlab:run_example unittest_tensor_mesh">run</a>)
%   unittest_tensor_mesh
%
% See also TENSOR_MESH, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_mesh' );


% test 1: one dimensional (trivial, but should be checked)
[xd,wd] = tensor_mesh({[1, 2, 3, 4, 5]},{[5; 6; 7; 8; 9]});
assert_equals( xd, [1, 2, 3, 4, 5], 'xd1' );
assert_equals( wd, [5; 6; 7; 8; 9], 'wd1' );


% test 2: two dimensional with different dimensions
[xd,wd] = tensor_mesh({[1, 2],[3, 4, 5]},{[5; 6],[7; 8; 9]});
[xd,ind]=sortrows( xd' );
wd=wd(ind);
assert_equals( xd, [1 3; 1 4; 1 5; 2 3; 2 4; 2 5], 'xd2' );
assert_equals( wd, [35; 40; 45; 42; 48; 54], 'wd2' );

% test 3: three dimensional (chosen such that xd maps to some binary
% representation and wd is exactly two to the power of that number) 
[xd,wd] = tensor_mesh({[0, 1],[0, 1], [0, 1]},{[1; 16],[1; 4], [1; 2]});
[xd,ind]=sortrows( xd' );
wd=wd(ind);
assert_equals( [4 2 1]*xd', 0:7, 'xd3' );
assert_equals( wd, 2.^(0:7)', 'wd3' );

% test 4: five dimensional (see test 3 for explanation)
[xd,wd] = tensor_mesh({[0, 1],[0, 1], [0, 1],[0, 1], [0, 1]},{[1; 65536],[1; 256],[1; 16],[1; 4], [1; 2]});
[xd,ind]=sortrows( xd' );
wd=wd(ind);
assert_equals( [16 8 4 2 1]*xd', 0:31, 'xd5' );
assert_equals( wd, 2.^(0:31)', 'wd5' );

% test 5: The following should go into the unit test
x1{1}=[1,2,3];
x1{2}=[4,5];
x1{3}=[6,7,8,9];
w1=x1;
xde =[
    1     2     3     1     2     3     1     2     3     1     2     3     1     2     3     1     2     3     1     2     3     1     2     3
    4     4     4     5     5     5     4     4     4     5     5     5     4     4     4     5     5     5     4     4     4     5     5     5
    6     6     6     6     6     6     7     7     7     7     7     7     8     8     8     8     8     8     9     9     9     9     9     9];
wde = [
    24    48    72    30    60    90    28    56    84    35    70   105    32    64    96    40    80   120    36    72   108    45    90   135 ]';
[xd,wd] = tensor_mesh(x1,w1);
assert_equals( xd, xde, 'points' );
assert_equals( wd, wde, 'weights' );

% test 6: error if dimensions of points and weights don't match
assert_error(@()(tensor_mesh({1, 1},{2})), 'sglib:', 'dimension_mismatch');

% test 7: only points
xd = tensor_mesh({[1, 2], [3, 4, 5]});
assert_equals(xd, [1, 2, 1, 2, 1, 2; 3, 3, 4, 4, 5, 5], 'points_only');
