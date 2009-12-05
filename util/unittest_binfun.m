function unittest_binfun
% UNITTEST_BINFUN Test the BINFUN function.
%
% Example (<a href="matlab:run_example unittest_binfun">run</a>)
%   unittest_binfun
%
% See also BINFUN, TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'binfun' );

A=ones(4,5);
B=1:5;
assert_equals( binfun( @plus, A, B ), repmat( 2:6, 4, 1), 'plus_horz' );

A=ones(4,5);
B=(1:4)';
assert_equals( binfun( @plus, A, B ), repmat( (2:5)', 1, 5), 'plus_vert' );


A=(1:4)';
B=1:5;
assert_equals( binfun( @times, A, B ), repmat( 1:5, 4, 1).*repmat( (1:4)', 1, 5), 'times_hv' );

assert_equals( binfun( @times, ones(4,3,5), ones(4,3,5) ), ones(4,3,5), 'tensor_3a' );
assert_equals( binfun( @times, ones(1,1,1), ones(4,3,5) ), ones(4,3,5), 'tensor_3b' );
assert_equals( binfun( @times, ones(4,3,5), ones(1,1,1) ), ones(4,3,5), 'tensor_3c' );
assert_equals( binfun( @times, ones(1,3,5), ones(4,1,5) ), ones(4,3,5), 'tensor_3d' );
assert_equals( binfun( @times, ones(1,3,1), ones(4,1,5) ), ones(4,3,5), 'tensor_3e' );
assert_equals( binfun( @times, ones(4,1,5), ones(1,3,1) ), ones(4,3,5), 'tensor_3f' );


func={@power,{},{}};
assert_equals( binfun( func, [1,2,3,4], [1;2] ), [1,2,3,4;1,4,9,16], 'func' );

A = magic(5);
A = binfun(@minus, A, mean(A));
C=[  4    11   -12    -5     2
    10    -8    -6     1     3
    -9    -7     0     7     9
    -3    -1     6     8   -10
    -2     5    12   -11    -4];
assert_equals( A, C, 'bsx_ex' );
