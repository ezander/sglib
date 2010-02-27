function unittest_linear_operator_compose
% UNITTEST_LINEAR_OPERATOR_COMPOSE Test the LINEAR_OPERATOR_COMPOSE function.
%
% Example (<a href="matlab:run_example unittest_linear_operator_compose">run</a>)
%   unittest_linear_operator_compose
%
% See also LINEAR_OPERATOR_COMPOSE, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'linear_operator_compose' );

% test the operator composition (not directly by all that follows)
munit_set_function( 'linear_operator_compose' );

M1=rand(12,10);
M2=rand(10,7);
x=rand(7,1);
y=M2*x;
z=M1*y;
s=size(M1*M2);

A1=linear_operator_from_matrix( M1 );
A2=linear_operator_from_matrix( M2 );
S1=linear_operator_from_matrix( M1, true );
S2=linear_operator_from_matrix( M2, true );

CAA=linear_operator_compose( A1, A2 );
CAM=linear_operator_compose( A1, M2 );
CMA=linear_operator_compose( M1, A2 );
CMM=linear_operator_compose( M1, M2 );
assert_equals( linear_operator_size( CAA ), s, 'CAA_size' );
assert_equals( linear_operator_size( CMM ), s, 'CMM_size' );
assert_equals( linear_operator_apply( CAA, x ), z, 'CAA' );
assert_equals( linear_operator_apply( CAM, x ), z, 'CAM' );
assert_equals( linear_operator_apply( CMA, x ), z, 'CMA' );
assert_equals( linear_operator_apply( CMM, x ), z, 'CMM' );

I=linear_operator_from_function( 'id' );
CAI=linear_operator_compose( A2, I );
CIA=linear_operator_compose( I, A2 );
CMI=linear_operator_compose( M2, I );
CIM=linear_operator_compose( I, M2 );
assert_equals( linear_operator_apply( CAI, x ), y, 'CAI' );
assert_equals( linear_operator_apply( CIA, x ), y, 'CIA' );
assert_equals( linear_operator_apply( CMI, x ), y, 'CMI' );
assert_equals( linear_operator_apply( CIM, x ), y, 'CIM' );

assert_equals( CMI, M2, 'CMI_M2' );
assert_equals( CIM, M2, 'CIM_M2' );
