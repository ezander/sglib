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

% test parameter placement
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

% test no output arg behaviour
s=evalc( 'funcall( @sin, 3 )' );
assert_true( any( strfind( s, '0.14' ) ), 'must output sin(3)', 'no_argout_sin' );

s=evalc( 'funcall( @noargout, 3 )' );
assert_true( any( strfind( s, 'noargout' ) ), 'noargoutout should see nargout==0', 'no_argout_0' );
x=funcall( @noargout, 3 );
assert_equals( x, 4, 'no_argout_1' );

% test behaviour with different function specs
% string 1
assert_equals( funcall( 'sin', 3 ), sin(3), 'string' );
assert_equals( funcall( {'sin'}, 3 ), sin(3), 'cell_string' );
assert_equals( funcall( {'sin', {3}} ), sin(3), 'cell_string2' );
assert_equals( funcall( {{'sin'}}, 3 ), sin(3), 'nest1' );
assert_equals( funcall( {{{'sin'}}}, 3 ), sin(3), 'nest2' );

assert_equals( funcall( {{{@sin}}}, 3 ), sin(3), 'nest4' );
times4={@times,{4}};
equal12={times4,{3}};
assert_equals( funcall( {equal12} ), 12, 'nest4' );


function [d,e]=test_it( a, b, c )
d=a+b; e=b*c;

function varargout=noargout(x)
if nargout==0
    disp('noargout');
else
    [varargout{1:nargout}]=x+1;
end