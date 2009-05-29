function test_tensor_operator_compose
% TEST_TENSOR_OPERATOR_COMPOSE Test the TENSOR_OPERATOR_COMPOSE function.
%
% Example (<a href="matlab:run_example test_tensor_operator_compose">run</a>) 
%    test_tensor_operator_compose
%
% See also TENSOR_OPERATOR_COMPOSE, TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'tensor_operator_compose' );

% some small integer matrices
A1={ [1 2; 3 4], [3 5 1; 6 4 2; 2 3 7 ] };
A2={ [1 1; 2 2], [1 1 1; 2 2 2; 3 3 3 ] };
A1M=tkron( A1 );
A2M=tkron( A2 );
x={[1;2], [6;3;2]}; xv=tkron(x);
y={A2{1}*A1{1}*x{1}, A2{2}*A1{2}*x{2}}; yv=tkron(y);

% in tensor format
A=tensor_operator_compose( A1, A2 );
assert_equals( A, {A2{1}*A1{1}, A2{2}*A1{2}}, 'comp1' );
assert_equals( tensor_operator_apply( A, x ), y, 'res1' );

% in matrix format
AM=tensor_operator_compose( A1M, A2 );
assert_equals( AM, A2M*A1M, 'comp2' );
AM=tensor_operator_compose( A1, A2M );
assert_equals( AM, A2M*A1M, 'comp3' );
AM=tensor_operator_compose( A1M, A2M );
assert_equals( AM, A2M*A1M, 'comp4' );
assert_equals( tensor_operator_apply( AM, xv ), yv, 'res1' );


% some larger random matrices
M1=3; K1=4; N1=6;
M2=2; K2=5; N2=7;
A1={ rand(K1,M1), rand(K2,M2); rand(K1,M1), rand(K2,M2); rand(K1,M1), rand(K2,M2);  };
A2={ rand(N1,K1), rand(N2,K2); rand(N1,K1), rand(N2,K2) };
A1M=tkron( A1 );
A2M=tkron( A2 );
R=3;
x={rand(M1,R), rand(M2,R)}; xv=reshape( x{1}*x{2}', [M1*M2,1]);
y=tensor_operator_apply( A2, tensor_operator_apply( A1, x ) );
yv=reshape( y{1}*y{2}', [N1*N2,1]);

% in tensor format
A=tensor_operator_compose( A1, A2 );
assert_equals( tkron(A), A2M*A1M, 'rcomp2' );
assert_equals( tensor_operator_apply( A, x ), y, 'res1' );

% in matrix format
AM=tensor_operator_compose( A1M, A2 );
assert_equals( AM, A2M*A1M, 'rcomp2' );
AM=tensor_operator_compose( A1, A2M );
assert_equals( AM, A2M*A1M, 'rcomp3' );
AM=tensor_operator_compose( A1M, A2M );
assert_equals( AM, A2M*A1M, 'rcomp4' );
assert_equals( tensor_operator_apply( AM, xv ), yv, 'res2' );

