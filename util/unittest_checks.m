function unittest_checks
% UNITTEST_CHECKS Test the CHECKS function.
%
% Example (<a href="matlab:run_example unittest_checks">run</a>)
%   unittest_checks
%
% See also CHECKS, TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'checks' );

assert_error( 'check_boolean( false, ''some_message'', ''abc'', ''mode'', ''error'' )', 'abc:check_failed', 'bool_fail1' );
assert_error( 'check_boolean( false, ''some_message'', '''', ''mode'', ''error'' )', 'check.*:check_failed', 'bool_fail2' );

