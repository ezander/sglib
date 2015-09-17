function unittest_gpcgerm_cdf
% UNITTEST_GPCGERM_CDF Test the GPCGERM_CDF function.
%
% Example (<a href="matlab:run_example unittest_gpcgerm_cdf">run</a>)
%   unittest_gpcgerm_cdf
%
% See also GPCGERM_CDF, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpcgerm_cdf' );

x = linspace(-3,3);
y = rand(size(x));

V=gpcbasis_create('h');
assert_equals(gpcgerm_cdf(V,x), normal_cdf(x), 'h');

V=gpcbasis_create('pl');
assert_equals(gpcgerm_cdf(V,[x;y]), uniform_cdf(x, -1, 1).*exponential_cdf(y, 1), 'pl');

V=gpcbasis_create('h', 'm', 2);
assert_equals(gpcgerm_cdf(V,[x;y]), normal_cdf(x).*normal_cdf(y), 'h2');

