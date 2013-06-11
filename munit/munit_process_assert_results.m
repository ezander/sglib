function munit_process_assert_results( result_list, assert_id, varargin )
% MUNIT_PROCESS_ASSERT_RESULTS Invoked when an assertion has failed.
%   MUNIT_ASSERT_FAILED( MESSAGE, ASSERT_ID, OPTIONS ) prints the error
%   message and increases the stats counter. All other fields are optional.
%   MESSAGE is a user defined message explaining what went wrong (e.g. if
%   actual and expected values didn't match or sizes of arrays weren't
%   equal). ASSERT_ID is a short string identifier which gives a hint as to
%   the 'category' of the assertion (e.g. if you are testing function 'xyz'
%   which operates on sets and you check the operation on the empty set you
%   could specify 'empty_set' as ASSERT_ID). 
%
%   OPTIONS can be given as a structure with the field names corresponding
%   to the option names, or as a list of arguments where each option name
%   precedes the options value. Supported options are: 
%     'fuzzy', 
%
%   MUNIT_ASSERT_FAILED should usually not be called directly from user code but rather
%   via some customized functions like ASSERT_EQUALS, MUNIT_SET_FUNCTION
%   and the like.
%
% Example (<a href="matlab:run_example assert">run</a>)
%
% See also ASSERT_EQUALS, ASSERT_TRUE, ASSERT_FALSE, MUNIT_SET_FUNCTION

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% initialize options to empty struct if not present
options=varargin2options(varargin);
[fuzzy,options]=get_option( options, 'fuzzy', false );
check_unsupported_options(options,mfilename);

function_name=munit_stats('get', 'function_name');
debug=munit_options('get', 'debug');

% if result list is empty assertion has passed
passed=isempty(result_list);
munit_stats( 'add', function_name, passed, fuzzy );
%module_name=munit_stats('get', 'module_name');
module_name=munit_stats('get', 'total_module_name');
current_assertion=munit_stats('get', 'current_assertion');

% for internal checking only
if ~isempty(assert_id)
    should_pass=strncmp(assert_id,'pass_',5);
    should_fail=strncmp(assert_id,'fail_',5);
    if should_pass && ~passed
        error( 'munit:internal_error', 'assertion should have passed' )
    end
    if should_fail && passed
        error( 'munit:internal_error', 'assertion should have failed' )
    end
end

% assemble printable assertion identifier
assert_name=sprintf( '%s/%s, assertion #%d', ...
    module_name, function_name, current_assertion );

% if assertion has passed, print result and bail out immediately
if passed
    if ~isempty( assert_id )
        assert_name=[assert_name, ' (', assert_id, ')' ];
    end
    munit_printf( 'assert_pass', 'Passed: %s', {assert_name} );
    return
end

% determine the caller is possible
if isversion('6')
    stack=struct2cell( dbstack('-completenames') );
    caller=find( strncmp( 'unittest_', stack(2,:), 5 ), 1, 'first' );
    if ~isempty(caller)
        assert_name=sprintf( '<a href="error:%s,%d,1">%s</a>', ...
            stack{1,caller}, stack{3,caller}, assert_name );
    end
else
    caller=[];
end

% change message if assertion was fuzzy
if fuzzy
    % count fuzzy failures extra
    fail='Possible failure';
else
    fail='Failure';
end

% now print the error stuff
num=length(result_list);
max_assertion_disp=get_option( options, 'max_assertion_disp', munit_options('get', 'max_assertion_disp') );
for i=1:min(num, max_assertion_disp)
    result=result_list{i};
    item_assert_id=assert_id;
    if iscell(result)
        message=result{1};
        if length(result)>=2
            item_assert_id=result{2};
        end
    else
        message=result;
    end

    curr_assert_name=assert_name;
    if ~isempty( item_assert_id )
        curr_assert_name=[assert_name, ' (', item_assert_id, ')' ];
    end
    munit_printf( 'assert_fail', '%s in %s: %s', {fail, curr_assert_name, message} );
end
if num>max_assertion_disp
    message='... further output suppressed ...';
    curr_assert_name=assert_name;
    if ~isempty( assert_id )
        curr_assert_name=[assert_name, ' (', assert_id, ')' ];
    end
    munit_printf( 'assert_fail', '%s in %s: %s', {fail, curr_assert_name, message} );
end


if debug && ~fuzzy
    munit_printf( 'assert_fail', '> Debugging is turned on and an assertion has failed' );
    if ~isempty(caller)
        cmd=repmat( 'dbup;', 1, caller-1 );
        munit_printf( 'assert_fail', '> use the stack to get to <a href="matlab:%s">the place the assertion failed</a> to', {cmd} );
        munit_printf( 'assert_fail', '> investigate the error. Then press F5 to <a href="matlab:dbcont;">continue</a> or <a href="matlab:dbquit;">stop debugging</a>.' );
    else
        munit_printf( 'assert_fail', '> use the stack to get to the place the assertion failed to');
        munit_printf( 'assert_fail', '> investigate the error. Then press F5 to continue.' )
    end
    keyboard;
end


