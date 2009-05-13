function test_funcall
% TEST_FUNCALL Test the FUNCALL function.
%
% Example (<a href="matlab:run_example test_funcall">run</a>) 
%    test_funcall
%
% See also TESTSUITE, FUNCALL

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'funcall' );

res=[5,12];

func=@test_it;
[d,e]=funcall( func, 2, 3, 4 );
assert_equals( [d,e], res, 'direct' );

func={@test_it, {}, {}};
[d,e]=funcall( func, 2, 3, 4 );
assert_equals( [d,e], res, 'direct2' );

func={@test_it, {2}, {1}};
[d,e]=funcall( func, 3, 4 );
assert_equals( [d,e], res, 'param1' );

func={@test_it, {3}, {2}};
[d,e]=funcall( func, 2, 4 );
assert_equals( [d,e], res, 'param2' );

func={@test_it, {4}, {3}};
[d,e]=funcall( func, 2, 3 );
assert_equals( [d,e], res, 'param3' );

func={@test_it, {4}};
[d,e]=funcall( func, 2, 3 );
assert_equals( [d,e], res, 'param_last' );




function [d,e]=test_it( a, b, c )
d=a+b; e=b*c;

