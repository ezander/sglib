function unittest_beta_find_ratio
% UNITTEST_BETA_FIND_RATIO Test the BETA_FIND_RATIO function.
%
% Example (<a href="matlab:run_example unittest_beta_find_ratio">run</a>)
%   unittest_beta_find_ratio
%
% See also BETA_FIND_RATIO, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'beta_find_ratio' );

[a,b]=beta_find_ratio( 5 );
assert_equals( a*b, 1, 'prod1' );
assert_equals( beta_ratio(a,b), 5, 'rat5' );

[a,b]=beta_find_ratio( 0.1 );
assert_equals( beta_ratio(a,b), 0.1, 'rat0_1' );

[a,b]=beta_find_ratio( 100 );
assert_equals( beta_ratio(a,b), 100, 'rat100' );

[a,b]=beta_find_ratio( 5, 'prod_ab', 3 );
assert_equals( a*b, 3, 'prod1' );
assert_equals( beta_ratio(a,b), 5, 'rat5' );


function r=beta_ratio(a,b)
[m,v]=beta_moments(a,b);
r=sqrt(v)/m;
