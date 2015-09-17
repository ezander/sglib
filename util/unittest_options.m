function unittest_options
% UNITTEST_OPTIONS Test the OPTIONS function.
%
% Example (<a href="matlab:run_example unittest_options">run</a>)
%   unittest_options
%
% See also OPTIONS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'varargin2options' );

internal = 'internal__';

% test 1 element varargin for list, cell, struct
options_exp=struct( 'foo', 1, 'bar', 'baz' );

options_act=varargin2options( {'foo', 1, 'bar', 'baz'} );
options_act=rmfield(options_act, internal);
assert_equals( options_act, options_exp, 'list' );

options_act=varargin2options( {struct( 'foo', 1, 'bar', 'baz' )} );
options_act=rmfield(options_act, internal);
assert_equals( options_act, options_exp, 'struct' );

options_act=varargin2options( {{ 'foo', 1, 'bar', 'baz' }} );
options_act=rmfield(options_act, internal);
assert_equals( options_act, options_exp, 'struct' );

% test 2 element varargin with repetition for list, cell

options_exp=struct( 'foo', 2, 'bar', 'baz' );

options_act=varargin2options( {'foo', 1, 'bar', 'baz', 'foo', 2} );
options_act=rmfield(options_act, internal);
assert_equals( options_act, options_exp, 'repeat' );

% test empty varargin for list, cell, struct
options_exp=struct();

options_act=varargin2options({});
options_act=rmfield(options_act, internal);
assert_equals( options_act, options_exp, 'empty' );

options_act=varargin2options({struct()});
options_act=rmfield(options_act, internal);
assert_equals( options_act, options_exp, 'empty_struct' );


% test errors for varargin2options
assert_error( 'varargin2options( struct() );', 'util:varargin2options:', 'no_cell1' );
assert_error( 'varargin2options( {struct(), ''a'', 1 } );', 'util:varargin2options:', 'args after struct' );
assert_error( 'varargin2options( {1,2} );', 'util:varargin2options:', 'invalid_name' );
assert_error( 'varargin2options( {''a''} );', 'util:varargin2options:', 'missing1' );
assert_error( 'varargin2options( {''a'',1,''b''} );', 'util:varargin2options:', 'missing2' );


% test errors for get_option
munit_set_function( 'get_option' );

assert_error( 'get_option({},''x'',1);', 'util:get_option', 'param_check1' );
assert_error( 'get_option(struct(),2,1);', 'util:get_option', 'param_check2' );
