function unittest_is_gvector
% UNITTEST_IS_TENSOR Test the IS_CTENSOR function.
%
% Example (<a href="matlab:run_example unittest_is_gvector">run</a>)
%   unittest_is_gvector
%
% See also IS_GVECTOR, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'is_gvector' );

assert_false( is_gvector('abc'), 'is_gvector(str)', 'string' );
assert_false( is_gvector(struct()), 'is_gvector(str)', 'struct' );

assert_true( is_gvector([]), 'is_gvector([])', 'empty' );
assert_true( is_gvector(ones(3,1)), 'is_gvector(arr)', 'full1' );
assert_true( is_gvector(ones(3,3)), 'is_gvector(arr)', 'full2' );
assert_true( is_gvector(ones(3,4,5)), 'is_gvector(arr)', 'full3' );

b=is_gvector( {ones(3,3), ones(5,5)} );
assert_equals(  b, false, 'no_canon' );
[b,f]=is_gvector( {ones(3,3), ones(5,3)} );
assert_equals(  b, true, 'canon' );
assert_equals(  f, 'canonical', 'canon_format' );
[b,f]=is_gvector( {ones(3,1), ones(5,1)} );
assert_equals(  b, true, 'canon2' );
assert_equals(  f, 'canonical', 'canon2_format' );

