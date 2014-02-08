function unittest_get_mfile_path
% UNITTEST_GET_MFILE_PATH Test the GET_MFILE_PATH function.
%
% Example (<a href="matlab:run_example unittest_get_mfile_path">run</a>)
%   unittest_get_mfile_path
%
% See also GET_MFILE_PATH, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'get_mfile_path' );

% we assume that the unittest is in the same dir as the function being
% tested
res=get_mfile_path();
exp=mfilename('fullpath');
exp=exp(1:length(res));
assert_equals( res, exp, 'unittest_path' );
