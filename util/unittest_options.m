function unittest_options
% UNITTEST_OPTIONS Test the OPTIONS function.
%
% Example (<a href="matlab:run_example unittest_options">run</a>)
%   unittest_options
%
% See also OPTIONS, TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'varargin2options' );

% test 2 element varargin for list, cell, struct
options_exp=struct( 'foo', 1, 'bar', 'baz', 'supported_fields__', {{}} );
options_act=varargin2options( 'foo', 1, 'bar', 'baz' );
assert_equals( options_act, options_exp, 'list' );

options_act=varargin2options( struct( 'foo', 1, 'bar', 'baz' ) );
assert_equals( options_act, options_exp, 'list_struct' );

options_act=varargin2options( { 'foo', 1, 'bar', 'baz' } );
assert_equals( options_act, options_exp, 'list_cell' );

% test 2 element varargin with repetition for list, cell

options_exp=struct( 'foo', 2, 'bar', 'baz', 'supported_fields__', {{}} );
options_act=varargin2options( 'foo', 1, 'bar', 'baz', 'foo', 2 );
assert_equals( options_act, options_exp, 'repeat' );

options_act=varargin2options( {'foo', 1, 'bar', 'baz', 'foo', 2} );
assert_equals( options_act, options_exp, 'repeat_cell' );

% test empty varargin for list, cell, struct
options_exp=struct( 'supported_fields__', {{}} );
options_act=varargin2options();
assert_equals( options_act, options_exp, 'empty' );

options_act=varargin2options(struct());
assert_equals( options_act, options_exp, 'empty_struct' );

options_act=varargin2options({});
assert_equals( options_act, options_exp, 'empty_cell' );




