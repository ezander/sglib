function assert_output( command, expected_output, assert_id )
% ASSERT_OUTPUT Assert that the console output of a command is correct.
%   ASSERT_OUTPUT( COMMAND, EXPECTED_OUTPUT, ASSERT_ID ) asserts that the
%   output on the console of the command COMMAND, which has to be specified
%   as a string, matches the string EXPECTED_OUTPUT.
%
% Example (<a href="matlab:run_example assert_output">run</a>)
%    assert_output( 'fprintf(''%03d'', 12)', '012', 'pass' )
%    assert_output( 'fprintf(''%03d'', 12)', '0012', 'fail' )
%
% See also ASSERT_EQUALS, ASSERT_TRUE, MUNIT_RUN_TESTSUITE

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

if nargin<3
    assert_id = [];
end

result_list={};
if exist('evalc')  %#ok<EXIST>
    if ~isempty(expected_output)
        expected_output=sprintf(expected_output);
    end
    if ischar(command)
        output = evalc(command);
    else
        output = evalc('funcall(command);');
    end
    if ~strcmp(output, expected_output)
        message = sprintf('command output was ''%s'', but ''%s'' was expected', output, expected_output);
        result_list{end+1}={message, assert_id};
    end
end
munit_process_assert_results( result_list, assert_id );
