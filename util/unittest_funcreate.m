function unittest_funcreate
% UNITTEST_FUNCREATE Test the FUNCREATE function.
%
% Example (<a href="matlab:run_example unittest_funcreate">run</a>)
%   unittest_funcreate
%
% See also FUNCREATE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'funcreate' );

% no arguments
func = funcreate(@test_fun, 'a', 'b', 'c', 'd', 'e');
assert_equals(funcall(func), {'a', 'b', 'c', 'd', 'e'}, 'no_arg');

% end arguments
func = funcreate(@test_fun, @ellipsis, 'd', 'e');
assert_equals(funcall(func, 'a', 'b', 'c'), {'a', 'b', 'c', 'd', 'e'}, 'end_args');

% pos arguments
func = funcreate(@test_fun, @funarg, 'b', @funarg, 'd', 'e');
assert_equals(funcall(func, 'a', 'c'), {'a', 'b', 'c', 'd', 'e'}, 'pos_args');

% pos and end arguments
func = funcreate(@test_fun, @funarg, 'b', @ellipsis, 'e');
assert_equals(funcall(func, 'a', 'c', 'd'), {'a', 'b', 'c', 'd', 'e'}, 'pos_end_args');


function retval=test_fun(a,b,c,d,e)
retval = {a,b,c,d,e};
