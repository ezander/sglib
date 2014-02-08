function unittest_is_tensor_operator
% UNITTEST_IS_TENSOR_OPERATOR Test the IS_TENSOR_OPERATOR function.
%
% Example (<a href="matlab:run_example unittest_is_tensor_operator">run</a>)
%   unittest_is_tensor_operator
%
% See also IS_TENSOR_OPERATOR, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'is_tensor_operator' );

A={rand(3,3),rand(4,4); rand(3,3),rand(4,4) };
assert_true( is_tensor_operator( A ), 'numeric_tensor_op' );

op=operator_from_matrix( rand(3,3) );
A={op, op; op, op };
assert_true( is_tensor_operator( A ), 'op_tensor_op' );



assert_true( is_tensor_operator( A ), 'numeric_tensor_op' );

A={rand(3,3),op,rand(4,4); rand(3,3),op,rand(4,4) };
assert_true( is_tensor_operator( A ), 'numop_tensor_op' );


assert_false( is_tensor_operator( op ), 'numop_tensor_op' );



