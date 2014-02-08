function unittest_checks
% UNITTEST_CHECKS Test the CHECKS function.
%
% Example (<a href="matlab:run_example unittest_checks">run</a>)
%   unittest_checks
%
% See also CHECKS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'check_boolean' );

assert_true( 'check_boolean( true, ''some_message'', ''abc'', ''mode'', ''error'' )', 'true passes', 'bool_pass' );
assert_error( 'check_boolean( false, ''some_message'', ''abc'', ''mode'', ''error'' )', 'abc:check_failed', 'bool_fail1' );
assert_error( 'check_boolean( false, ''some_message'', '''', ''mode'', ''error'' )', 'check.*:check_failed', 'bool_fail2' );


munit_set_function( 'check_scalar' );
assert_true( check_scalar( 1, false, 'x' ), [], 'num1' );
assert_true( check_scalar( 2, true, 'x' ), [], 'num2' );
assert_true( check_scalar( [], true, 'x' ), [], 'empty_ok' );
assert_error( 'check_scalar( [], false, ''x'', ''foo'', ''mode'', ''error'' );', 'foo:check.*', 'empty_not_ok' );
assert_error( 'check_scalar( [1 2], false, ''x'', ''foo'', ''mode'', ''error'' );', 'foo:check.*', 'vector1' );
assert_error( 'check_scalar( [1 2], true, ''x'', ''foo'', ''mode'', ''error'' );', 'foo:check.*', 'vector2' );


munit_set_function( 'check_vector' );
assert_true( check_vector( 1, false, 'x' ), [], 'num1' );
assert_true( check_vector( 2, true, 'x' ), [], 'num2' );
assert_true( check_vector( [], true, 'x' ), [], 'empty_ok' );
assert_error( 'check_vector( [], false, ''x'', ''foo'', ''mode'', ''error'' );', 'foo:check.*', 'empty_not_ok' );
assert_error( 'check_vector( [1 2; 3 4], false, ''x'', ''foo'', ''mode'', ''error'' );', 'foo:check.*', 'matrix' );
assert_error( 'check_vector( [1 2; 3 4], true, ''x'', ''foo'', ''mode'', ''error'' );', 'foo:check.*', 'matrix2' );


