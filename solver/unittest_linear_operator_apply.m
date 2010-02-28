function unittest_linear_operator_apply
% UNITTEST_LINEAR_OPERATOR_APPLY Test the LINEAR_OPERATOR_APPLY function.
%
% Example (<a href="matlab:run_example unittest_linear_operator_apply">run</a>)
%   unittest_linear_operator_apply
%
% See also LINEAR_OPERATOR_APPLY, TESTSUITE 

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

munit_set_function( 'linear_operator_apply' );

M=rand(5,3);
x=rand(3,1);
y=M*x;
A1=linear_operator_from_matrix( M );
A2=linear_operator_from_function( {@mtimes, {M}, {1}}, size(M) );
A3=linear_operator_from_matrix( M, 'solve' );
A4=linear_operator_from_matrix( M, 'solve', 'use_lu', true );
A5=linear_operator_from_matrix( sparse(M), 'solve', 'use_lu', true );
I=linear_operator_from_function( 'id' );

assert_equals( linear_operator_apply( M, x ), y, 'M' );
assert_equals( linear_operator_apply( A1, x ), y, 'A1' );
assert_equals( linear_operator_apply( A2, x ), y, 'A2' );
assert_equals( linear_operator_apply( A3, y ), x, 'A3' );
assert_equals( linear_operator_apply( A4, y ), x, 'A4' );
assert_equals( linear_operator_apply( A5, y ), x, 'A5' );

assert_equals( linear_operator_apply( I, x ), x, 'Ix' );
assert_equals( linear_operator_apply( I, y ), y, 'Iy' );
