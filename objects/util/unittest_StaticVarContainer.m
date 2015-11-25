function unittest_StaticVarContainer(varargin)
% UNITTEST_STATICVARCONTAINER Test the STATICVARCONTAINER function.
%
% Example (<a href="matlab:run_example unittest_StaticVarContainer">run</a>)
%   unittest_StaticVarContainer
%
% See also STATICVARCONTAINER, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'StaticVarContainer' );

c = StaticVarContainer('foo', 2, 'bar', [1,2,3]);
assert_equals(c.foo, 2, 'foo');
assert_equals(c.bar, [1,2,3], 'bar');
assert_equals(sort(properties(c)), {'bar'; 'foo'}, 'properties');

c = StaticVarContainer();
assert_equals(sort(properties(c)), cell(0,1), 'empty');
