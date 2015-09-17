function unittest_tensor_operator_apply_elementary
% UNITTEST_TENSOR_OPERATOR_APPLY_ELEMENTARY Test the TENSOR functions.
%
% Example (<a href="matlab:run_example unittest_tensor_operator_apply_elementary">run</a>)
%    unittest_tensor_operator_apply_elementary
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_operator_apply_elementary' );

% test order 2 tensors with matrix and "operator" operators
T={rand(8,3), rand(10,3)};
A={rand(8,8), rand(10,10)};
L1=operator_from_matrix(A{1});
L2=operator_from_matrix(A{2});
B={L1, L2};
C={A{1}, L2};
UA=tensor_operator_apply_elementary(A,T);
UB=tensor_operator_apply_elementary(B,T);
UC=tensor_operator_apply_elementary(C,T);
assert_equals( UA, {A{1}*T{1}, A{2}*T{2}}, 'mat' );
assert_equals( UB, {A{1}*T{1}, A{2}*T{2}}, 'op' );
assert_equals( UC, {A{1}*T{1}, A{2}*T{2}}, 'mat_op' );

% test order 2 tensors with full tensors

U_ex=ctensor_to_array( UA );
U=tensor_operator_apply_elementary(A, ctensor_to_array( T ));
assert_equals( U, U_ex, 'full_mat' );
U=tensor_operator_apply_elementary(B, ctensor_to_array( T ));
assert_equals( U, U_ex, 'full_op' );
U=tensor_operator_apply_elementary(C, ctensor_to_array( T ));
assert_equals( U, U_ex, 'full_mat_op' );

% test order 4 tensors with matrix operator
T={rand(8,3), rand(10,3), rand(12,3), rand(13,3)};
A={rand(8,8), rand(10,10), rand(12,12), rand(13,13)};
U=tensor_operator_apply_elementary(A, T);
assert_equals( U, {A{1}*T{1}, A{2}*T{2}, A{3}*T{3}, A{4}*T{4}}, 'ord4' );



