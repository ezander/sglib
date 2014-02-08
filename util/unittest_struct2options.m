function unittest_struct2options
% UNITTEST_STRUCT2OPTIONS Test the STRUCT2OPTIONS function.
%
% Example (<a href="matlab:run_example unittest_struct2options">run</a>)
%   unittest_struct2options
%
% See also STRUCT2OPTIONS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'struct2options' );

s.foo='bar';
s.baz=42;

assert_equals( struct2options(s), {'foo', 'bar', 'baz', 42 }, 'foobar' );

