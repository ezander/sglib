function unittest_tensor_operator_compose
% UNITTEST_TENSOR_OPERATOR_COMPOSE Test the TENSOR_OPERATOR_COMPOSE function.
%
% Example (<a href="matlab:run_example unittest_tensor_operator_compose">run</a>)
%    unittest_tensor_operator_compose
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
A={ [1 1; 2 2], [1 1 1; 2 2 2; 3 3 3 ] };
B={ [1 2; 3 4], [3 5 1; 6 4 2; 2 3 7 ] };
AM=revkron( A );
BM=revkron( B );
x={[1;2], [6;3;2]}; xv=revkron(x);
y={A{1}*B{1}*x{1}, A{2}*B{2}*x{2}}; yv=revkron(y);

% in tensor format
C=tensor_operator_compose( A, B );
assert_equals( C, {A{1}*B{1}, A{2}*B{2}}, 'comp1' );
assert_equals( tensor_operator_apply( C, x ), y, 'res1' );

% in matrix format
CM=tensor_operator_compose( AM, B );
assert_equals( CM, AM*BM, 'comp2' );
CM=tensor_operator_compose( A, BM );
assert_equals( CM, AM*BM, 'comp3' );
CM=tensor_operator_compose( AM, BM );
assert_equals( CM, AM*BM, 'comp4' );
assert_equals( tensor_operator_apply( CM, xv ), yv, 'res1' );


% some larger random matrices
M1=3; K1=4; N1=6;
M2=2; K2=5; N2=7;
A={ rand(N1,K1), rand(N2,K2); rand(N1,K1), rand(N2,K2) };
B={ rand(K1,M1), rand(K2,M2); rand(K1,M1), rand(K2,M2); rand(K1,M1), rand(K2,M2);  };
AM=revkron( A );
BM=revkron( B );
R=3;
x={rand(M1,R), rand(M2,R)}; xv=reshape( x{1}*x{2}', [M1*M2,1]);
y=tensor_operator_apply( A, tensor_operator_apply( B, x ) );
yv=reshape( y{1}*y{2}', [N1*N2,1]);

% in tensor format
C=tensor_operator_compose( A, B );
assert_equals( revkron(C), AM*BM, 'rcomp2' );
assert_equals( tensor_operator_apply( C, x ), y, 'res1' );

% in matrix format
CM=tensor_operator_compose( AM, B );
assert_equals( CM, AM*BM, 'rcomp2' );
CM=tensor_operator_compose( A, BM );
assert_equals( CM, AM*BM, 'rcomp3' );
CM=tensor_operator_compose( AM, BM );
assert_equals( CM, AM*BM, 'rcomp4' );
assert_equals( tensor_operator_apply( CM, xv ), yv, 'res2' );

