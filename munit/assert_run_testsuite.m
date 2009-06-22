function assert_run_testsuite( module_name, curr_dir, varargin )
% ASSERT_RUN_TESTSUITE Runs all tests in one directory.
%   ASSERT_RUN_TESTSUITE( MODULE_NAME, CURR_DIR ) runs all tests (contained
%   in M-files matching "test_*.m") in the directory specified by CURR_DIR
%   under the module name MODULE_NAME.
%
% Options:
%   subdir: {auto}
%     Runs ASSERT_RUN_TESTSUITE recursively in all subdirectories. Passing
%     a cell array of relative pathnames runs ASSERT_RUN_TESTSUITE only in
%     the given subdirs. Default is empty cell array ({}).
%
% Example
%   assert_reset_options();
%   assert_set_debug( true );
%   assert_run_testsuite( 'mymod', pwd, 'subdirs', {'submod1', 'submod2'} );
%
% See also ASSERT, ASSERT_SET_MODULE, ASSERT_SET_DEBUG,
%   ASSERT_RESET_OPTIONS

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

options=varargin2options( varargin{:} );
[subdirs,options]=get_option( options, 'subdirs', {} );
[prefix,options]=get_option( options, 'prefix', 'ut_' );
check_unsupported_options( options, mfilename );

% TODO: function should run really recursively, maybe looking for all
% subdirs that include testsuite, or were explicitly specified.
% the otherwise passing the prefix along

[stats,options]=assert(); %#ok
output_func=options.output_func;

% get subdirs
if ischar( subdirs ) 
    if strcmp('subdirs', 'auto' )
        subdirs={};
        files=dir(pwd);
        for i=1:length(files)
            file=files(i);
            if file.isdir && file.name(1)~='.';
                subdirs={subdirs{:}, file.name };
            end
        end
    end
end

% print banner
notice=sprintf( '  Testing module: %s  ', module_name );
output_func( repmat('-', 1, length(notice) ) );
output_func( notice );
output_func( repmat('-', 1, length(notice) ) );

assert_set_module( module_name );
for subdir={'.', subdirs{:} }
    pattern=sprintf( '%s/%s/%s*.m', curr_dir, subdir{1}, prefix );
    files=dir( pattern );

    for i=1:length(files)
        test_cmd=files(i).name(1:end-2);
        output_func( sprintf('Running: %s/%s', subdir{1}, test_cmd ) );
        
        slash_pos=find(test_cmd=='/');
        if ~isempty(slash_pos)
          test_cmd=test_cmd( slash_pos(end)+1:end );
        end

        if strcmp( test_cmd, 'test_suite' )
            warning( 'assert_run_testsuite:test_suite', 'not running test "test_suite", better rename in "testsuite"' );
        else
            clr=safe_eval( test_cmd );
            if clr
                warning( 'assert:clear', ['Test function has cleared caller''s workspace (' test_cmd ').'] );
            end
        end
    end
end
assert_print_module_stats();


function clr=safe_eval( test_cmd )
% SAFE_EVAL Evaluate command safely catching errors and detecting attempts to clear the callers workspace.

% Comments on some unresolved problems here: if the called script is a
% script and not a function it may call 'clear' and thus erase the
% workspace needed here. If I wrap all this into try/catch this works but
% we don't get nice error messages anymore if a real error happened.

%TODO: find a good solution for this (i.e. call safely without nessesarily
%aborting the testsuite and give good error output)

assert_run_testsuite_test_var=1; %#ok
eval( test_cmd );
% try
%     eval( test_cmd );
% catch
%     warning( 'assert:eval', ['Problem evaluating test command (' lasterr ').'] );
% end
clr=~exist('assert_run_testsuite_test_var', 'var');
