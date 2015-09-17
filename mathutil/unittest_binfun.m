function unittest_binfun
% UNITTEST_BINFUN Test the BINFUN function.
%
% Example (<a href="matlab:run_example unittest_binfun">run</a>)
%   unittest_binfun
%
% See also BINFUN, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'binfun' );

% Test 1: 4x5 plus 1x5
A=ones(4,5);
B=1:5;
assert_equals( binfun( @plus, A, B), repmat( 2:6, 4, 1), 'plus_horz_no' );
assert_equals( binfun( @plus, A, B, 'avoid_bsxfun', true), repmat( 2:6, 4, 1), 'plus_horz' );
assert_equals( binfun( @plus, A, B, 'avoid_bsxfun', false), repmat( 2:6, 4, 1), 'plus_horz_bsx' );

% Test 2: 4x5 plus 4x1
A=ones(4,5);
B=(1:4)';
assert_equals( binfun( @plus, A, B, 'avoid_bsxfun', true), repmat( (2:5)', 1, 5), 'plus_vert' );
assert_equals( binfun( @plus, A, B, 'avoid_bsxfun', false), repmat( (2:5)', 1, 5), 'plus_vert_bsx' );

% Test 3: 4x1 times 1x5
A=(1:4)';
B=1:5;
assert_equals( binfun( @times, A, B, 'avoid_bsxfun', true), repmat( 1:5, 4, 1).*repmat( (1:4)', 1, 5), 'times_hv' );
assert_equals( binfun( @times, A, B, 'avoid_bsxfun', false), repmat( 1:5, 4, 1).*repmat( (1:4)', 1, 5), 'times_hv_bsx' );

% Test 4a: test 3rd order tensors without bsxfun
nobsx = struct('avoid_bsxfun', true);
assert_equals( binfun( @times, ones(4,3,5), ones(4,3,5), nobsx), ones(4,3,5), 'tensor_3a' );
assert_equals( binfun( @times, ones(1,1,1), ones(4,3,5), nobsx), ones(4,3,5), 'tensor_3b' );
assert_equals( binfun( @times, ones(4,3,5), ones(1,1,1), nobsx), ones(4,3,5), 'tensor_3c' );
assert_equals( binfun( @times, ones(1,3,5), ones(4,1,5), nobsx), ones(4,3,5), 'tensor_3d' );
assert_equals( binfun( @times, ones(1,3,1), ones(4,1,5), nobsx), ones(4,3,5), 'tensor_3e' );
assert_equals( binfun( @times, ones(4,1,5), ones(1,3,1), nobsx), ones(4,3,5), 'tensor_3f' );

% Test 4b: test 3rd order tensors with bsxfun
assert_equals( binfun( @times, ones(4,3,5), ones(4,3,5) ), ones(4,3,5), 'tensor_3a_bsx' );
assert_equals( binfun( @times, ones(1,1,1), ones(4,3,5) ), ones(4,3,5), 'tensor_3b_bsx' );
assert_equals( binfun( @times, ones(4,3,5), ones(1,1,1) ), ones(4,3,5), 'tensor_3c_bsx' );
assert_equals( binfun( @times, ones(1,3,5), ones(4,1,5) ), ones(4,3,5), 'tensor_3d_bsx' );
assert_equals( binfun( @times, ones(1,3,1), ones(4,1,5) ), ones(4,3,5), 'tensor_3e_bsx' );
assert_equals( binfun( @times, ones(4,1,5), ones(1,3,1) ), ones(4,3,5), 'tensor_3f_bsx' );

% Test 5: test from the matlab documentation of bsxfun
A = magic(5);
C=[  4    11   -12    -5     2
    10    -8    -6     1     3
    -9    -7     0     7     9
    -3    -1     6     8   -10
    -2     5    12   -11    -4];
assert_equals( binfun(@minus, A, mean(A), nobsx), C, 'bsx_ex' );
assert_equals( binfun(@minus, A, mean(A)), C, 'bsx_ex_bsx' );

% Test 6: sglib function that can only be called with funcall
func={@power,{},{}};
assert_equals( binfun( func, [1,2,3,4], [1;2] ), [1,2,3,4;1,4,9,16], 'func' );

% Test 7: incompatible dimensions
A=ones(4,5);
B=1:6;
assert_error( {@binfun, {@plus, A, B, nobsx}}, 'MATLAB:bsxfun:arrayDimensionsMustMatch', 'err1' );
assert_error( {@binfun, {@plus, A, B}}, 'MATLAB:bsxfun:arrayDimensionsMustMatch', 'err1_bsx' );
