function unittest_roundat
% UNITTEST_ROUNDAT Test the ROUNDAT function.
%
% Example (<a href="matlab:run_example unittest_roundat">run</a>)
%   unittest_roundat
%
% See also ROUNDAT, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'roundat' );

a=[ 1 2 1.3 1.23 1.27 1.3 1.29 1.31 ];

assert_equals( roundat( a, 1 ), [ 1 2 1 1 1 1 1 1 ] );
assert_equals( roundat( a, 0.1 ), [ 1 2 1.3 1.2 1.3 1.3 1.3 1.3 ] );
assert_equals( roundat( a, 0.2 ), [ 1 2 1.4 1.2 1.2 1.4 1.2 1.4 ] );
assert_equals( roundat( a, 0.01 ), a );
assert_equals( roundat( a, 0.001 ), a );
assert_equals( roundat( a, 2 ), [ 2 2 2 2 2 2 2 2 ] );
assert_equals( roundat( a, 5 ), 0*a );

assert_equals( roundat( [], 0.1 ), [] );
assert_equals( roundat( a', 0.01 ), a' );
