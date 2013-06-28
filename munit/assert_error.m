function assert_error( eval_func, expect_err_id, assert_id)
% ASSERT_ERROR Asserts that the called function emits a correct error.
%   ASSERT_ERROR Long description of assert_error.
%
% Example (<a href="matlab:run_example assert_error">run</a>)
%    A=rand(3);
%    B=rand(4);
%    assert_error( {@times, {A,B}, {1,2}}, 'MATLAB:dimagree', 'matdim_match' )
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3
    assert_id=[];
end

result_list={};
try
    if ischar(eval_func)
        eval(eval_func);
    else
        funcall( eval_func );
    end
    result_list{end+1}={'no error was raised as expected', assert_id};
catch %#ok<CTCH>
    err_struct=lasterror; %#ok<LERR>
    if regexp( err_struct.identifier, expect_err_id )
        % ok
    else
        msg=sprintf('raised error ''%s'' did not match regexp ''%s''', ...
            err_struct.identifier, expect_err_id );
        result_list{end+1}={msg, assert_id};
    end
end
munit_process_assert_results( result_list, assert_id );
