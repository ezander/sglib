function unittest_SimpleMap(varargin)
% UNITTEST_SIMPLEMAP Test the SIMPLEMAP function.
%
% Example (<a href="matlab:run_example unittest_SimpleMap">run</a>)
%   unittest_SimpleMap
%
% See also SIMPLEMAP, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'SimpleMap' );


% Create map and add some values
map = SimpleMap();
map.add('foo', 1234)
map.add('bar', 'abcde')

assert_equals(map.count(), 2, 'count');
assert_true(map.iskey('foo'), 'key exists', 'exists');
assert_false(map.iskey('xxx'), 'key does not exist', 'notexists');
assert_equals(map.keys, {'foo'; 'bar'}, 'keys');
assert_equals(map.values, {1234; 'abcde'}, 'vals');

% Overwrite one value
map.add('foo', 123)
assert_equals(map.keys, {'foo'; 'bar'}, 'keys2');
assert_equals(map.values, {123; 'abcde'}, 'vals2');

% Test the get method
assert_equals(map.get('foo'), 123, 'get_str');
assert_equals(map.get(1), 123, 'get_num');
assert_equals(map.get('foo', 777), 123, 'get_default');
assert_equals(map.get('foob', 777), 777, 'get_default2');

% Test the find_key method
assert_equals(map.find_key('foo'), 1, 'find1');
assert_equals(map.find_key('bar'), 2, 'find2');
assert_equals(map.find_key('foob'), 0, 'findx');

% Test the tostring method
assert_equals(map.tostring(), 'Map(foo => 123, bar => abcde)', 'tostring');
