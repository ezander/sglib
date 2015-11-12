function ret_code = sglib_unattended_test(interactive)
% SGLIB_UNATTENDED_TEST Runs an unattended test of the sglib testsuite.
%   SGLIB_UNATTENDED_TEST(FALSE) is meant to be run from the command line
%   in order to run the full suite of unit tests without halting and
%   reporting the result back to the operating system. The codes returned
%   to the OS are 0, if nothing failed, 1, if an error occurred, 2, if one
%   or more assertions failed, and 3, if one of thoses "fuzzy" assertions
%   failed. 
%
% Note: this functions automatically returns to the operating system if
%   INTERACTIVE is set to false. If set to true or not specified, the
%   return code is just returned to the calling function.
%
% Example (<a href="matlab:run_example sglib_unattended_test">run</a>)
%   sglib_unattended_test
%
% See also SGLIB_TESTSUITE

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

if nargin<1
    interactive = true;
end

munit_options( 'set', 'debug', false );
munit_options( 'set', 'compact', 0 );
munit_options( 'set', 'on_error', 'rethrow' );
dbclear if error
dbclear if warning

ret_code = 0;
try
    sglib_testsuite
catch err
    disp(err.getReport)
    ret_code = 1;
end

if ret_code == 0
    stats = munit_stats;
    if stats.assertions_failed>0
        ret_code = 2;
    elseif stats.assertions_failed_poss>0
        ret_code = 3;
    end
end

if ~interactive
    exit(ret_code);
end
