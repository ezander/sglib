function assert_error( eval_func, expect_err_id, assert_id, varargin )
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
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

noerror=false;
try
    funcall( eval_func );
    noerror=true;
catch
    if noerror
        fprintf( 'error not caught\n' );
    else
        s=lasterror;
        fprintf( '%s\n', s.identifier );
    end
end
