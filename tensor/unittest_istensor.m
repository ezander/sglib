function unittest_is_tensor
% UNITTEST_IS_TENSOR Test the IS_TENSOR function.
%
% Example (<a href="matlab:run_example unittest_is_tensor">run</a>)
%   unittest_is_tensor
%
% See also IS_TENSOR, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'is_tensor' );

assert_false( is_tensor('rand(3,4)'), 'is_tensor(str)', 'numeric' );
assert_false( is_tensor('abc'), 'is_tensor(str)', 'string' );
assert_false( is_tensor(struct()), 'is_tensor(str)', 'struct' );

b=is_tensor( {ones(3,3), ones(5,5)} );
assert_equals(  b, false, 'no_canon' );
b=is_tensor( {ones(3,3), ones(5,3)} );
assert_equals(  b, true, 'canon' );
b=is_tensor( {ones(3,1), ones(5,1)} );
assert_equals(  b, true, 'canon2' );

