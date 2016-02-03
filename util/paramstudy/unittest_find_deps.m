function unittest_find_deps(varargin)
% UNITTEST_FIND_DEPS Test the FIND_DEPS function.
%
% Example (<a href="matlab:run_example unittest_find_deps">run</a>)
%   unittest_find_deps
%
% See also FIND_DEPS, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'find_deps' );

if isversion('8.6')
    % TODO: doesn't work with 8.6, caused by the change in depfun and a bug
    % in the new requiredToolAndProducts function which I don't want to
    % debug right now.
    return
end

files = find_deps('filedate');
expect = {fullfile(pwd, 'filedate.m')};
assert_equals(files, expect, 'single');


files = find_deps('needs_update');
expect = {fullfile(pwd, 'filedate.m'); fullfile(pwd, 'needs_update.m')};
assert_equals(files, expect, 'multiple');
