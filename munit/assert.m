function [ret_stats,ret_options]=assert( condition, message, assert_id, varargin )
% ASSERT Swiss army knife of the assertion package.
%   [STATS,OPTIONS]=ASSERT() called without any arguments ASSERT
%   returns the current assertion statistics and currently set options.
%
%   ASSERT( CONDITION, MESSAGE, ASSERT_ID, OPTIONS ) called this
%   way ASSERT checks the condition (i.e. whether the boolean value in
%   CONDITION is true or false) and prints an appropriate message. All
%   other fields are optional. MESSAGE is a user defined message explaining
%   what went wrong (e.g. if actual and expected values didn't match or
%   sizes of arrays weren't equal). ASSERT_ID is a short string identifier
%   which gives a hint as to the 'category' of the assertion (e.g. if you
%   are testing function 'xyz' which operates on sets and you check the
%   operation on the empty set you could specify 'empty_set' as ASSERT_ID).
%   OPTIONS passed in this way are valid only for this call to ASSERT.
%
%   ASSERT( [], [], [], OPTIONS ) sets some assert options like
%   'FUNCTION_NAME' and 'MODULE_NAME'. The options set in this way are
%   permanent.
%
%   OPTIONS can be given as a structure with the field names corresponding
%   to the option names, or as a list of arguments where each option name
%   precedes the options value. Currently supported options are: 'abstol',
%   'reltol' and 'debug', 'fuzzy', 'no_step', 'function_name', 'module_name'. The
%   latter two should only be set without performing an assertion, since
%   they have to be set permanently and require the statistics to be reset.
%   
%   ASSERT should usually not be called directly from user code but rather
%   via some customized functions like ASSERT_EQUALS, ASSERT_SET_FUNCTION
%   and the like.
%
% Example (<a href="matlab:run_example assert">run</a>)
%    % Set current function name
%    options.function_name='xyz';
%    assert( [], [], [], options );
%    % Do some cheching
%    assert( xyz([])==0, 'xyz([]) should be zero', 'empty_set' );
%    % query current stats
%    stats=assert();
%    disp( stats.assertion_failed_function );
%    disp( stats.assertion_total_function );
%
% See also ASSERT_EQUALS, ASSERT_TRUE, ASSERT_FALSE, ASSERT_SET_FUNCTION,
%    ASSERT_SET_MODULE

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


%TODO: maybe options should be held in a different function
%TODO: better provision for fuzzy tests

persistent stats options

% initialize stats if called for the first time
if isempty(stats)
    stats.current_assertion=0;
    stats.assertion_failed_module=0;
    stats.assertion_failed_function=0;
    stats.assertion_failed_poss_module=0;
    stats.assertion_failed_poss_function=0;
    stats.assertion_total_module=0;
    stats.assertion_total_function=0;
    stats.tested_functions={};
end

% initialize options if called for the first time
if isempty(options)
    options=assert_reset_options();
    % only set the unchangeable options inside 
    options.fuzzy=false;
    options.no_step=false;
end

% with no input arguments return current stats
if nargin==0
    ret_stats=stats;
    ret_options=options;
    return;
end

% initialize options to empty struct if not present
curr_options=varargin2options( varargin{:} );

% if condition is empty we rather set options than check anything
if isempty(condition)
    if isfield( curr_options, 'module_name' )
        options.module_name=curr_options.module_name;
        options.function_name='<not set>';
        stats.current_assertion=0;
        stats.assertion_failed_module=0;
        stats.assertion_failed_function=0;
        stats.assertion_failed_poss_module=0;
        stats.assertion_failed_poss_function=0;
        stats.assertion_total_module=0;
        stats.assertion_total_function=0;
        curr_options=rmfield( curr_options, 'module_name' );
    end
    if isfield( curr_options, 'function_name' )
        options.function_name=curr_options.function_name;
        stats.current_assertion=0;
        stats.assertion_failed_function=0;
        stats.assertion_failed_poss_function=0;
        stats.assertion_total_function=0;
        curr_options=rmfield( curr_options, 'function_name' );
        stats.tested_functions={stats.tested_functions{:}, options.function_name};
    end
    
    [curr_options, options]=transfer_option( curr_options, options, 'debug' );
    [curr_options, options]=transfer_option( curr_options, options, 'abstol' );
    [curr_options, options]=transfer_option( curr_options, options, 'reltol' );
    [curr_options, options]=transfer_option( curr_options, options, 'output_func' );
    [curr_options, options]=transfer_option( curr_options, options, 'max_assertion_disp' );

    if ~isempty(fieldnames(curr_options))
        warning( 'assert:options', 'can''t set permanently or option unknown: %s', evalc( 'disp(curr_options);' ) );
    end
    return
end

% increase error count if not precluded by 'no_step'
no_step=get_option( curr_options, 'no_step', options.no_step );
if ~no_step
    stats.current_assertion=stats.current_assertion+1;
    stats.assertion_total_module=stats.assertion_total_module+1;
    stats.assertion_total_function=stats.assertion_total_function+1;
end

% assemble printable assertion identifier
assertion_id=sprintf( '%s/%s, assertion #%d', options.module_name, ...
    options.function_name, stats.current_assertion );

if nargin>=3 && ~isempty( assert_id )
    assertion_id=sprintf( '%s (%s)', assertion_id, assert_id );
end

if ~condition && isversion('6')
    stack=struct2cell( dbstack('-completenames') );
    caller=find( strncmp( 'test_', stack(2,:), 5 ), 1, 'first' );
    if ~isempty(caller)
        assertion_id=sprintf( '<a href="error:%s,%d,1">%s</a>', ...
            stack{1,caller}, stack{3,caller}, assertion_id );
    end
else
    caller=[];
end
    

% check condition and show failure/passed respectively
output_func=get_option( curr_options, 'output_func', options );
fuzzy=get_option( curr_options, 'fuzzy', options );
debug=get_option( curr_options, 'debug', options );
if ~condition
    if fuzzy
        % count fuzzy failures extra
        fail='Possible failure';
        if ~no_step
            stats.assertion_failed_poss_module=stats.assertion_failed_poss_module+1;
            stats.assertion_failed_poss_function=stats.assertion_failed_poss_function+1;
        end
    else
        fail='Failure';
        if ~no_step
            stats.assertion_failed_module=stats.assertion_failed_module+1;
            stats.assertion_failed_function=stats.assertion_failed_function+1;
        end
    end
    if nargin<2 || isempty(message)
        output_func( sprintf( '%s in %s: <no message>', fail, assertion_id) );
    else
        output_func( sprintf( '%s in %s: %s', fail, assertion_id, message ) );
    end

    if debug && ~fuzzy 
        output_func( '> Debugging is turned on and an assertion has failed' );
        if ~isempty(caller) && isversion('6') 
            cmd=repmat( 'dbup;', 1, caller-1 );
            output_func( sprintf( '> use the stack to get to <a href="matlab:%s">the place the assertion failed</a> to', cmd ) );
            output_func( '> investigate the error. Then press F5 to <a href="matlab:dbcont;">continue</a> or <a href="matlab:dbquit;">stop debugging</a>.' )
        else
            output_func( '> use the stack to get to the place the assertion failed to');
            output_func( '> investigate the error. Then press F5 to continue.' )
        end
        keyboard;
    end

else
    output_func( sprintf( 'Passed: %s', assertion_id ) );
end

function [curr_options, options]=transfer_option( curr_options, options, fieldname )
% TRANSFER_OPTION Transfers an option from the current options to the
% permanent options and removes from the current options struct.

if isfield( curr_options, fieldname )
    options.(fieldname)=curr_options.(fieldname);
    curr_options=rmfield( curr_options, fieldname );
end
