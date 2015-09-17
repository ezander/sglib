function unittest_tensor_operator_extend
% UNITTEST_TENSOR_OPERATOR_EXTEND Test the TENSOR_OPERATOR_EXTEND function.
%
% Example (<a href="matlab:run_example unittest_tensor_operator_extend">run</a>)
%   unittest_tensor_operator_extend
%
% See also TENSOR_OPERATOR_EXTEND, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_operator_extend' );

A={ {1}, {2}, {3}; {4} {5} {6}};
Ax1={ {1}, {2}, {3}, {1 2 3}; {4} {5} {6}, {1 2 3}};
Ax2={ {0}, {1}, {2}, {3}; {0}, {4} {5} {6}};
Ax3={ {1}, {9}, {2}, {3}; {4}, {9} {5} {6}};

assert_equals( tensor_operator_extend( A, {1,2,3} ), Ax1 );
assert_equals( tensor_operator_extend( A, {1,2,3}, 4 ), Ax1 );
assert_equals( tensor_operator_extend( A, {0}, 1 ), Ax2 );
assert_equals( tensor_operator_extend( A, {9}, 2 ), Ax3 );
