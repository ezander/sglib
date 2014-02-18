function unittest_operator_compose
% UNITTEST_OPERATOR_COMPOSE Test the OPERATOR_COMPOSE function.
%
% Example (<a href="matlab:run_example unittest_operator_compose">run</a>)
%   unittest_operator_compose
%
% See also OPERATOR_COMPOSE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'operator_compose' );

% test the operator composition (not directly by all that follows)

M1=rand(12,10);
M2=rand(10,7);
x=rand(7,1);
y=M2*x;
z=M1*y;
s=size(M1*M2);

A1=operator_from_matrix( M1 );
A2=operator_from_matrix( M2 );
S1=operator_from_matrix( M1, true );
S2=operator_from_matrix( M2, true );

CAA=operator_compose( A1, A2 );
CAM=operator_compose( A1, M2 );
CMA=operator_compose( M1, A2 );
CMM=operator_compose( M1, M2 );
assert_equals( operator_size( CAA ), s, 'CAA_size' );
assert_equals( operator_size( CMM ), s, 'CMM_size' );
assert_equals( operator_apply( CAA, x ), z, 'CAA' );
assert_equals( operator_apply( CAM, x ), z, 'CAM' );
assert_equals( operator_apply( CMA, x ), z, 'CMA' );
assert_equals( operator_apply( CMM, x ), z, 'CMM' );

I=operator_from_function( 'id' );
CAI=operator_compose( A2, I );
CIA=operator_compose( I, A2 );
CMI=operator_compose( M2, I );
CIM=operator_compose( I, M2 );
assert_equals( operator_apply( CAI, x ), y, 'CAI' );
assert_equals( operator_apply( CIA, x ), y, 'CIA' );
assert_equals( operator_apply( CMI, x ), y, 'CMI' );
assert_equals( operator_apply( CIM, x ), y, 'CIM' );

assert_equals( CMI, M2, 'CMI_M2' );
assert_equals( CIM, M2, 'CIM_M2' );


% tensor operator stuff

M1={rand(12,10), rand(13,11)};
M2={rand(10,7), rand(11, 8)};
x={rand(7,2), rand(8,2)};
y=operator_apply(M2, x);
zex=operator_apply(M1, y);

M=operator_compose(M1, M2);
z=operator_apply(M, x);
assert_equals( z, zex, 'tensor')
assert_equals( size(M{1}), [12, 7], 'tensor_sz')

M=operator_compose(M1, M2, 'tensor_sum', false);
z=operator_apply(M, x);
assert_equals( z, zex, 'tensor')
assert_equals( M{3}, 'op_marker', 'tensor_op')
