function test_linear_operator
% TEST_LINEAR_OPERATOR Test the LINEAR_OPERATOR and related functions.
%
% Example (<a href="matlab:run_example test_linear_operator">run</a>) 
%    test_linear_operator
%
% See also LINEAR_OPERATOR, LINEAR_OPERATOR_SIZE, LINEAR_OPERATOR_APPLY,
% LINEAR_OPERATOR_COMPOSE, TESTSUITE

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



% there is not much point in bigger matrices here, just check that basic
% functionality works
M=[1, 2; 3, 4; 5, 10];
x=[1; 5];
y=M*x;
s=size(M);
linop1=linear_operator( M );
linop2={ size(M), {@mtimes, {M}, {1} } };
linop3={ linop2{:}, {@mldivide, {M}, {1} } };

assert_set_function( 'linear_operator_size' );

assert_equals( linear_operator_size( M ), s, 'M_size' );
assert_equals( linear_operator_size( linop1 ), s, 'lo1_size' );
assert_equals( linear_operator_size( linop2 ), s, 'lo2_size' );
assert_equals( linear_operator_size( linop3 ), s, 'lo3_size' );

assert_set_function( 'linear_operator_size' );

assert_equals( linear_operator_apply( M, x ), y, 'M_apply' );
assert_equals( linear_operator_apply( linop1, x ), y, 'lo1_apply' );
assert_equals( linear_operator_apply( linop2, x ), y, 'lo2_apply' );
assert_equals( linear_operator_apply( linop3, x ), y, 'lo3_apply' );

assert_set_function( 'linear_operator_solve' );

M=[1, 2, 3; 3, 4, 6; 5, 10, 14];
x=[1; 5; 7];
y=M*x;
linop1=linear_operator( M );
linop2={ size(M), {@mtimes, {M}, {1} } };
linop3={ linop2{:}, {@mldivide, {M}, {1} } };

assert_equals( linear_operator_solve( M, y ), x, 'M_solve' );
assert_equals( linear_operator_solve( linop1, y ), x, 'lo1_solve' );
assert_equals( linear_operator_solve( linop2, y ), x, 'lo2_solve' );
assert_equals( linear_operator_solve( linop3, y ), x, 'lo3_solve' );

% test the operator composition (not directly by all that follows)
assert_set_function( 'linear_operator_compose' );

M1=[1, 2 4; 3, 4 7; 5, 10, 2; 6, 6, 5];
M2=[4 3 2 5; 2 6 4 8; 1 1 2 5];
x=[1; 5; 2];
y=M2*M1*x;
s=size(M2*M1);
linop1=linear_operator_compose( M2, M1 );
linop2=linear_operator_compose( linear_operator(M2), linear_operator(M1), 'step_solve', false );
linop3=linear_operator_compose( linear_operator(M2), linear_operator(M1) );

assert_equals( linear_operator_size( linop1 ), s, 'loc1_size' );
assert_equals( linear_operator_size( linop2 ), s, 'loc2_size' );
assert_equals( linear_operator_apply( linop1, x ), y, 'loc1_apply' );
assert_equals( linear_operator_apply( linop2, x ), y, 'loc2_apply' );
assert_equals( linear_operator_solve( linop1, y ), x, 'loc1_solve' );
assert_equals( linear_operator_solve( linop2, y ), x, 'loc2_solve', 'abstol', 1e-4 );
% the result doesn't match the input (x) in this case but it shows that the
% result is indeed computed step by step (which is inaacurate since the
% matrices are 4x3 and 3x4 and the second step has to be solved in a least squares fashion)
assert_equals( linear_operator_solve( linop3, y ), M1\(M2\y), 'loc3_solve' );
