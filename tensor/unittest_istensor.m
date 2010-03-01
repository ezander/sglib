function unittest_istensor
% UNITTEST_ISTENSOR Test the ISTENSOR function.
%
% Example (<a href="matlab:run_example unittest_istensor">run</a>)
%   unittest_istensor
%
% See also ISTENSOR, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'istensor' );

assert_false( istensor('rand(3,4)'), 'istensor(str)', 'numeric' );
assert_false( istensor('abc'), 'istensor(str)', 'string' );
assert_false( istensor(struct()), 'istensor(str)', 'struct' );

b=istensor( {ones(3,3), ones(5,5)} );
assert_equals(  b, false, 'no_canon' );
b=istensor( {ones(3,3), ones(5,3)} );
assert_equals(  b, true, 'canon' );
b=istensor( {ones(3,1), ones(5,1)} );
assert_equals(  b, true, 'canon2' );

