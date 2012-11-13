function unittest_operator_size
% UNITTEST_OPERATOR_SIZE Test the OPERATOR_SIZE function.
%
% Example (<a href="matlab:run_example unittest_operator_size">run</a>)
%   unittest_operator_size
%
% See also OPERATOR_SIZE, TESTSUITE 

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

munit_set_function( 'operator_size' );

M=rand(5,3);
A1=operator_from_matrix( M );
A2=operator_from_function( @uplus, [6,6] );
A3=operator_from_matrix( M, 'solve' );
A4=operator_from_matrix( M, 'solve', 'use_lu', true );
I=operator_from_function( 'id' );

assert_equals( operator_size( M ), [5,3], 'M_size' );
assert_equals( operator_size( A1 ), [5,3], 'A1_size' );
assert_equals( operator_size( A2 ), [6,6], 'A2_size' );
assert_equals( operator_size( A3 ), [3,5], 'A3_size' );
assert_equals( operator_size( A4 ), [3,5], 'A4_size' );
assert_equals( operator_size( I ), [0,0], 'I_size' );

