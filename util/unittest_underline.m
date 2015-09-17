function unittest_underline
% UNITTEST_UNDERLINE Test the UNDERLINE function.
%
% Example (<a href="matlab:run_example unittest_underline">run</a>)
%   unittest_underline
%
% See also UNDERLINE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'underline' );

assert_equals( underline('abc'), sprintf('abc\n==='), 'abc' );
assert_output( 'underline(''abc'');', 'abc\n===\n', 'abc_disp' );
assert_output( 'xxx=underline(''abc'');', '', 'no_disp' );


