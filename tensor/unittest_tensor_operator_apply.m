function unittest_tensor_operator_apply
% UNITTEST_TENSOR_OPERATOR_APPLY Test the TENSOR_OPERATOR_APPLY function.
%
% Example (<a href="matlab:run_example unittest_tensor_operator_apply">run</a>)
%    unittest_tensor_operator_apply
%
% See also TENSOR_OPERATOR_APPLY, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'tensor_operator_apply' );


% here tensor operators (non-square and square) and vectors are computed in
% different formats and results are checked against each other

R=3; RX=3;
M1=3; N1=4;
M2=2; N2=6;

A=cell(R,2);
Alin=cell(R,2);

X={rand(N1,RX), rand(N2,RX)};
Xmat=ctensor_to_array(X);
Xvec=ctensor_to_vector(X);
B={zeros(M1,0), zeros(M2,0)};
for i=1:R
    A(i,1:2)={rand(M1,N1), rand(M2,N2) };
    Alin{i,1}=operator_from_matrix(A{i,1});
    Alin{i,2}=operator_from_matrix(A{i,2});
    
    B={[B{1}, A{i,1}*X{1}], [B{2}, A{i,2}*X{2}] };
end
Bmat=ctensor_to_array(B);
Bvec=ctensor_to_vector(B);


assert_equals( tensor_operator_apply( A, X, 'reverse', false ), B, 'tensor/tensor' );
assert_equals( ctensor_to_array(tensor_operator_apply( A, X)), Bmat, 'tensor/tensor' );
assert_equals( tensor_operator_apply( A, Xvec ), Bvec, 'tensor/vect' );
assert_equals( tensor_operator_apply( A, Xmat ), Bmat, 'tensor/mat' );

assert_equals( tensor_operator_apply( Alin, X, 'reverse', false ), B, 'lin_op_tensor/tensor' );

