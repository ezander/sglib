function unittest_randn_sorted
% UNITTEST_RANDN_SORTED Test the RANDN_SORTED function.
%
% Example (<a href="matlab:run_example unittest_randn_sorted">run</a>)
%   unittest_randn_sorted
%
% See also RANDN_SORTED, MUNIT_RUN_TESTSUITE 

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

assert_equals( randn_sorted(1), 0, '1' );
assert_equals( randn_sorted(2), [-1; 1]/sqrt(2), '2' );
assert_equals( randn_sorted(3), [-1; 0; 1], '3' );
