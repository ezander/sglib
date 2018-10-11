function unittest_empirical_invcdf(varargin)
% UNITTEST_EMPIRICAL_INVCDF Test the EMPIRICAL_INVCDF function.
%
% Example (<a href="matlab:run_example unittest_empirical_invcdf">run</a>)
%   unittest_empirical_invcdf
%
% See also EMPIRICAL_INVCDF, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2018, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'empirical_invcdf' );

rand_seed(908);
dist = gendist_create('normal', {2, 3});
x = [0.025, 0.975];
y = gendist_sample(10000, dist);
assert_equals(gendist_invcdf(x, dist), empirical_invcdf(y, x), 'normal', 'abstol', 0.2);

dist = gendist_create('beta', {1, 4});
x = [0.25, 0.75];
y = gendist_sample(10000, dist);
assert_equals(gendist_invcdf(x, dist), empirical_invcdf(y, x), 'beta', 'abstol', 0.2);

