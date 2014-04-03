function unittest_gpc_covariance
% UNITTEST_GPC_COVARIANCE Test the GPC_COVARIANCE function.
%
% Example (<a href="matlab:run_example unittest_gpc_covariance">run</a>)
%   unittest_gpc_covariance
%
% See also GPC_COVARIANCE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpc_covariance' );

V = gpcbasis_create('HlP', 'p', 4);
M = gpcbasis_size(V, 1);

Na = 10;
a_i_alpha = rand(Na, M);
Nb = 7;
b_j_alpha = rand(Nb, M);

cov_ab = gpc_covariance(a_i_alpha, V, b_j_alpha);
cov_a = gpc_covariance(a_i_alpha, V);
cov_ab2 = gpc_covariance([a_i_alpha; b_j_alpha], V);

assert_equals( cov_ab2(1:Na, 1:Na), cov_a, 'foo')
assert_equals( cov_ab2(1:Na, Na+1:end), cov_ab, 'foo')


%%
m=3;
p=4;
V = gpcbasis_create('H', 'm', m, 'p', p);
M = gpcbasis_size(V, 1);

Na = 10;
a_i_alpha = rand(Na, M);

cov_a = gpc_covariance(a_i_alpha, V);
cov_a_old = pce_covariance(a_i_alpha, V{2});
assert_equals(cov_a, cov_a_old, 'foobar');


%% Empty basis
V = gpcbasis_create('H', 'm', 0, 'p', p);
M = gpcbasis_size(V, 1);
Na = 10;
a_i_alpha = rand(Na, M);

cov_a = gpc_covariance(a_i_alpha, V);
assert_equals(cov_a, zeros(Na), 'emptyV');


%% Empty coefficient field
V = gpcbasis_create('H', 'm', 1, 'p', p);
M = gpcbasis_size(V, 1);
Na = 0;
a_i_alpha = rand(Na, M);

cov_a = gpc_covariance(a_i_alpha, V);
assert_equals(cov_a, zeros(Na), 'empty_a');



