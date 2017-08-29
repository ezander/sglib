function unittest_disp_func(varargin)
% UNITTEST_DISP_FUNC Test the DISP_FUNC function.
%
% Example (<a href="matlab:run_example unittest_disp_func">run</a>)
%   unittest_disp_func
%
% See also DISP_FUNC, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2017, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'disp_func' );

fun1 = funcreate(@testtest, @funarg, 'foo', @funarg, 'bar', @ellipsis, 'baz');
assert_equals(disp_func(fun1), ...
    '@testtest(<arg1>, ''foo'', <arg2>, ''bar'', ..., ''baz'')');

fun2 = funcreate('foobar', @funarg, 'foo');
assert_equals(disp_func(fun2), ...
    'foobar(<arg1>, ''foo'')');

fun2 = funcreate('foobar', @funarg, 'foo');
assert_equals(disp_func(fun2, 'indent', true), ...
    sprintf('foobar(\n  <arg1>,\n  ''foo'')'));

fun3 = funcreate(123, @funarg, 'foo');
assert_error(funcreate(@disp_func, fun3), 'sglib:unknown_func_type');

