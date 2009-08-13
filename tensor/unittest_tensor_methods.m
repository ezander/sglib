function unittest_tensor_methods
% UNITTEST_TENSOR_METHODS Test the TENSOR functions.
%
% Example (<a href="matlab:run_example unittest_tensor_methods">run</a>) 
%    unittest_tensor_methods
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% testing function TENSOR_NULL
assert_set_function( 'tensor_null' );

T={rand(8,3), rand(10,3)};
Z=tensor_null(T);
assert_equals( norm( Z{1}*Z{2}', 'fro' ), 0, 'norm' );
assert_equals( size(Z{1}), [8,0], 'size_1' );
assert_equals( size(Z{2}), [10,0], 'size_2' );

% testing function TENSOR_ADD
assert_set_function( 'tensor_add' );

T1={rand(8,2), rand(10,2)};
T2={rand(8,3), rand(10,3)};
Z=tensor_add(T1,T2,3);
assert_equals( Z{1}*Z{2}', T1{1}*T1{2}'+3*T2{1}*T2{2}', 'sum' )
assert_equals( size(Z{1}), [8,5], 'size_1' );
assert_equals( size(Z{2}), [10,5], 'size_2' );


% testing function TENSOR_SCALE
assert_set_function( 'tensor_scale' );

T={rand(8,2), rand(10,2)};
S=tensor_scale(T,-3);
assert_equals( S{1}*S{2}', -3*T{1}*T{2}', 'scale' )
Z=tensor_scale(T,0);
assert_equals( Z{1}*Z{2}', zeros(8,10), 'scale_zero' )


% testing function TENSOR_NORM
assert_set_function( 'tensor_norm' );

T={rand(8,2), rand(10,2)};
normT=norm( T{1}*T{2}', 'fro' );
normT2=sqrt(trace( T{1}*T{2}'*T{2}*T{1}' ));
assert_equals( normT, normT2, 'check_test' );
assert_equals( tensor_norm( T, 'svd' ), normT, 'svd' );
assert_equals( tensor_norm( T, 'full' ), normT, 'full' );
assert_equals( tensor_norm( T, 'inner' ), normT, 'inner' );

Z=tensor_add(T,T,-1);
assert_equals( tensor_norm( Z, 'svd' ), 0, 'zero_svd', 'abstol', 1e-7 );
assert_equals( tensor_norm( Z, 'full' ), 0, 'zero_full' );
assert_equals( tensor_norm( Z, 'inner' ), 0, 'zero_inner', 'abstol', 1e-7 );

M1=rand(8); M1=M1*M1';
M2=rand(10); M2=M2*M2';
normT=sqrt(trace( M1*T{1}*T{2}'*M2*T{2}*T{1}' ));
assert_equals( tensor_norm( T, 'svd', M1, M2 ), normT, 'svd' );
assert_equals( tensor_norm( T, 'full', M1, M2 ), normT, 'full' );
assert_equals( tensor_norm( T, 'inner', M1, M2 ), normT, 'inner' );


% testing function TENSOR_SCALAR_PRODUCT

% implicitly test through tensor_norm 
% TODO: test tensor_scalar_product explicitly

assert_set_function( 'tensor_scalar_product' );

T1={rand(8,4), rand(10,4) };
T2={rand(8,3), rand(10,3) };
M1=rand(8); M1=M1*M1';
M2=rand(10); M2=M2*M2';
t1=reshape(T1{1}*T1{2}',[],1);
t2=reshape(T2{1}*T2{2}',[],1);
s=tensor_scalar_product(T1,T2);
assert_equals( s, t1'*t2, 'inner' );
s=tensor_scalar_product(T1,T2,'M1',M1);
assert_equals( s, t1'*revkron(M1,eye(size(M2)))*t2, 'inner_M1' );
s=tensor_scalar_product(T1,T2,'M2',M2);
assert_equals( s, t1'*revkron(eye(size(M1)),M2)*t2, 'inner_M2' );
s=tensor_scalar_product(T1,T2,'M1',M1,'M2',M2);
assert_equals( s, t1'*revkron(M1,M2)*t2, 'inner_M1_M2' );

%assert_equals( tensor_norm( T, 'svd', M1, M2 ), normT, 'svd' );
%assert_equals( tensor_norm( T, 'full', M1, M2 ), normT, 'full' );
%assert_equals( tensor_norm( T, 'inner', M1, M2 ), normT, 'inner' );


% testing function TENSOR_APPLY
assert_set_function( 'tensor_apply' );

A={rand(8,8), rand(10,10)};
B={@(x)(A{1}*x), @(x)(A{2}*x)};
C={A{1}, @(x)(A{2}*x)};
UA=tensor_apply(A,T);
UB=tensor_apply(B,T);
UC=tensor_apply(C,T);
assert_equals( UA{1}*UA{2}', UB{1}*UB{2}' );
assert_equals( UA{1}*UA{2}', UC{1}*UC{2}' );

% testing function TENSOR_APPLY
assert_set_function( 'tensor_operator_solve_elementary' );
A={M1+eye(size(M1)), M2+eye(size(M2))};
Uex=tensor_apply({inv(A{1}),inv(A{2})},T);
U1=tensor_operator_solve_elementary(A,T);
U2=tensor_operator_solve_elementary({linear_operator(A{1}),linear_operator(A{2})},T);
assert_equals( U1{1}*U1{2}', Uex{1}*Uex{2}' );
assert_equals( U2{1}*U2{2}', Uex{1}*Uex{2}' );


