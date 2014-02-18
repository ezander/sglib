function unittest_gpc_cdf_1d
% UNITTEST_GPC_CDF_1D Test the GPC_CDF_1D function.
%
% Example (<a href="matlab:run_example unittest_gpc_cdf_1d">run</a>)
%   unittest_gpc_cdf_1d
%
% See also GPC_CDF_1D, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_cdf_1d' );


%%
X_alpha=[30, 2, 0];
V_X=gpcbasis_create('H', 'm', 1, 'p', 2);

x = linspace(23, 35, 50);
y=gpc_cdf_1d(X_alpha, V_X, x );
y_ex=normal_cdf(x, 30, 2);
assert_equals(y, y_ex, 'shifted');

%%
X_alpha=[1, 0, 1];
V_X=gpcbasis_create('H', 'm', 1, 'p', 2);
x = linspace(0, 5, 20);
y=gpc_cdf_1d(X_alpha, V_X, x );
y_ex=chisquared_cdf(x,1);
assert_equals(y, y_ex, 'chisquared');

%%
%TODO: remove pce_expand here, test other distribution
deg=18;
X_alpha = pce_expand_1d(@exp, deg);
V_X=gpcbasis_create('H', 'm', 1, 'p', deg);

x = linspace(-1, 5, 30);
y=gpc_cdf_1d(X_alpha, V_X, x );
y_ex=lognormal_cdf(x,0,1);
assert_equals(y, y_ex, 'lognorm');

%%
% test error message
V=gpcbasis_create('HH', 'p', 3);
M=gpcbasis_size(V,1);
a_alpha = rand(1, M);
assert_error(funcreate(@gpc_cdf_1d, a_alpha, V, rand(M,3)), 'sglib:gpc_cdf', 'err_multivar');
