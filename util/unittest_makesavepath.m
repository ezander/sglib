function unittest_makesavepath
% UNITTEST_MAKESAVEPATH Test the MAKESAVEPATH function.
%
% Example (<a href="matlab:run_example unittest_makesavepath">run</a>)
%   unittest_makesavepath
%
% See also MAKESAVEPATH, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'makesavepath' );

dirname=tempname;
filename=fullfile( dirname, 'xxx' );
makesavepath(filename);
assert_true( exist(dirname,'dir'), 'directory was not created', 'create_dir' );
if exist(dirname,'dir')
    rmdir(dirname);
end



