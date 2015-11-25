function munit_run_with_coverage(func_or_unittest)
% MUNIT_RUN_WITH_COVERAGE Runs tests with code coverage.
%   MUNIT_RUN_WITH_COVERAGE(FUNC_OR_UNITTEST) runs the tests for the
%   function, mfile or unittest specified by FUNC_OR_UNITTEST, and displays
%   code coverage afterwards. The function/unittest must reside in the
%   current directory.
%
%   MUNIT_RUN_WITH_COVERAGE runs the testsuite with code coverage
%   for the current directory and subdirectories.
%
% Example (<a href="matlab:run_example munit_run_with_coverage">run</a>)
%   munit_run_with_coverage my_function_under_test
%
% See also MUNIT_RUN_TEST_SUITE

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin>0
    pathstr=find_containing_dir(func_or_unittest);
    munit_run_testsuite('coverage', true, 'dir', pathstr, 'include_only', {func_or_unittest}, 'subdirs', {});
else
    munit_run_testsuite('coverage', true);
end

function pathstr=find_containing_dir(func_or_unittest)
% FIND_CONTAINING_DIR Finds the directory that contains the test.
prefix = munit_options('get', 'prefix');
if strncmp(func_or_unittest, prefix, length(prefix))
    func = func_or_unittest(length(prefix)+1:end);
else
    func = func_or_unittest;
end
unittest = [prefix func];
if ~exist(['./' unittest '.m'], 'file')
    pathstr = fileparts(which(unittest));
else
    pathstr = pwd;
end
