function assert_run_testsuite( module_name, curr_dir )
% ASSERT_RUN_TESTSUITE Runs all tests in one directory.
%   ASSERT_RUN_TESTSUITE( MODULE_NAME, CURR_DIR ) runs all tests (contained
%   in M-files matching "test_*.m") in the directory specified by CURR_DIR
%   under the module name MODULE_NAME.
%
% Example
%   assert_reset_options();
%   assert_set_debug( true );
%   assert_run_testsuite( 'mymod', pwd );
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


notice=sprintf( '  Testing module: %s  ', module_name );
disp( repmat('-', 1, length(notice) ) );
disp( notice );
disp( repmat('-', 1, length(notice) ) );

assert_set_module( module_name );

pattern=sprintf( '%s/test_*.m', curr_dir);
files=dir( pattern );

for i=1:length(files)
    test_cmd=files(i).name(1:end-2);
    slash_pos=find(test_cmd=='/');
    if ~isempty(slash_pos)
      test_cmd=test_cmd( slash_pos(end)+1:end );
    end

    if strcmp( test_cmd, 'test_suite' )
        warning( 'assert_run_testsuite:test_suite', 'not running test "test_suite", better rename in "testsuite"' );
    else
        clr=safe_eval( test_cmd );
        if clr
            warning( ['Test function has cleared caller''s workspace (' test_cmd ').'] );
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

eval( test_cmd );
try
    %eval( test_cmd );
catch
    warning( ['Problem evaluating test command (' lasterr ').'] );
end
clr=~exist('test_cmd');
