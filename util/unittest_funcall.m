function unittest_funcall
% UNITTEST_FUNCALL Test the FUNCALL function.
%
% Example (<a href="matlab:run_example unittest_funcall">run</a>)
%    unittest_funcall
%
% See also TESTSUITE, FUNCALL

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'funcall' );

% old tests
assert_equals( funcall( {@power,{3}},2 ), 8, 'nopos' );
assert_equals( funcall( {@(y,x)(power(x,y)),{3}},2 ), 9, 'anon' );
assert_equals( funcall( {@power,{3},{2}},2 ), 8, 'pos2' );
assert_equals( funcall( {@power,{3},{1}},2 ), 9, 'pos1' );


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
if ismatlab
  s=evalc( 'funcall( @upper, ''asdf'' )' );
  assert_true( any( strfind( s, 'ASDF' ) ), 'must output ''ASDF''', 'no_argout_upper' );

  s=evalc( 'funcall( @noargout, 3 )' );
  assert_true( any( strfind( s, 'noargout' ) ), 'noargoutout should see nargout==0', 'no_argout_0' );
end
x=funcall( @noargout, 3 );
assert_equals( x, 4, 'no_argout_1' );

assert_error( 'funcall( {@power,[3],{1}},2 );', 'util:funcall', 'param_error1' );
assert_error( 'funcall( {@power,{3},[1]},2 );', 'util:funcall', 'param_error2' );



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

%% Test error reporting when in/out args don't match
assert_error( @()(funcall(funcreate(@take2return0,5,6,@funarg),3)), 'sglib:TooManyInputs', 'too_many_inputs');
assert_error( @()(1+funcall(funcreate(@take2return0,6,@funarg),3)), 'sglib:TooManyOutputs', 'too_many_outputs');

function [d,e]=test_it( a, b, c )
d=a+b; e=b*c;

function varargout=noargout(x)
if nargout==0
    disp('noargout');
else
    [varargout{1:nargout}]=x+1;
end

function take2return0(a,b) %#ok<INUSD>
