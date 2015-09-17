function unittest_khatriraorev
% UNITTEST_KHATRIRAOREV Test the KHATRIRAOREV function.
%
% Example (<a href="matlab:run_example unittest_khatriraorev">run</a>)
%   unittest_khatriraorev
%
% See also KHATRIRAOREV, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'khatriraorev' );

M=13; N=17; R=7;
A=randn( M, R );
B=randn( N, R );
C = khatriraorev( A, B );
assert_equals( sum( C, 2 ), reshape(A*B', [], 1), 'sum' );
assert_equals( C(:,1), kron(B(:,1), A(:,1)), 'col1' );
assert_equals( C(:,7), kron(B(:,7), A(:,7)), 'col7' );

assert_error(funcreate(@khatriraorev, rand(3,4), rand(3,5)), 'sglib:', 'err_dimen');
