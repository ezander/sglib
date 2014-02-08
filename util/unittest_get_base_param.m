function unittest_get_base_param
% UNITTEST_GET_BASE_PARAM Test the GET_BASE_PARAM function.
%
% Example (<a href="matlab:run_example unittest_get_base_param">run</a>)
%   unittest_get_base_param
%
% See also GET_BASE_PARAM, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'get_base_param' );

r=get_base_param( 'r', 10, 'caller' );
assert_equals( r, 10, 'default' );
r=5;
r=get_base_param( 'r', 10, 'caller' );
assert_equals( r, 5, 'set' );
clear r;
r=get_base_param( 'r', 20, 'caller' );
assert_equals( r, 20, 'default2' );


assignin( 'base', 'xyz', 1.2 );
r=get_base_param( 'xyz', 3.4, 'base' );
assert_equals( r, 1.2, 'baseval' );

evalin( 'base', 'clear xyz');
r=get_base_param( 'xyz', 3.4, 'base' );
assert_equals( r, 3.4, 'basedef' );
