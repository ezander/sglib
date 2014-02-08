function unittest_sqrspace
% UNITTEST_SQRSPACE Test the SQRSPACE function.
%
% Example (<a href="matlab:run_example unittest_sqrspace">run</a>)
%   unittest_sqrspace
%
% See also SQRSPACE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'sqrspace' );

x = sqrspace(2, 5, 44);
assert_equals(sqrt(x), linspace(sqrt(2), sqrt(5), 44), 'sqrt');
assert_equals(x([1,end]), [2, 5], 'endpoints');

x = sqrspace(5, 2, 44);
assert_equals(sqrt(x), linspace(sqrt(5), sqrt(2), 44), 'rev_sqrt');
assert_equals(x([1,end]), [5, 2], 'rev_endpoints');

x = sqrspace(-2, 5, 44);
assert_equals(size(x), [1, 44], 'neg_size');
assert_equals(x([1,end]), [-2, 5], 'neg_endpoints');

x = sqrspace(2, -5);
assert_equals(size(x), [1, 100], 'neg_rev_size');
assert_equals(x([1,end]), [2, -5], 'neg_rev_endpoints');
