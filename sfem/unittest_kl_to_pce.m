function unittest_kl_to_pce(varargin)
% UNITTEST_KL_TO_PCE Test the KL_TO_PCE function.
%
% Example (<a href="matlab:run_example unittest_kl_to_pce">run</a>)
%   unittest_kl_to_pce
%
% See also KL_TO_PCE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'kl_to_pce' );

munit_control_rand('seed' );

% Note: we check everything by evaluation
% First set the parameters and generate multiindex
N = 20;
m = 3;
p = 5;
L = 7;
M = multiindex_size(m, p);
I_r = multiindex(m, p, 'ordering', 'random');

% generate the coefficients as random numbers
mu_r_i = rand(N, 1);
r_i_k = rand(N, L);
sigma_k = rand(L, 1);
r_k_alpha = rand(L, M);

% points to evaluate the KL and PCE at
xi = rand(m, 30);


% Test without sigmas and mean (different calling conventions)
r_i_alpha = kl_to_pce([], r_i_k, [], r_k_alpha, I_r);
assert_equals(pce_evaluate(r_i_alpha, I_r, xi), r_i_k * pce_evaluate(r_k_alpha, I_r, xi))

r_i_alpha = kl_to_pce([], r_i_k, [], r_k_alpha);
assert_equals(pce_evaluate(r_i_alpha, I_r, xi), r_i_k * pce_evaluate(r_k_alpha, I_r, xi))

r_i_alpha = kl_to_pce(r_i_k, r_k_alpha);
assert_equals(pce_evaluate(r_i_alpha, I_r, xi), r_i_k * pce_evaluate(r_k_alpha, I_r, xi))

% Test without sigmas
r_i_alpha = kl_to_pce(mu_r_i, r_i_k, [], r_k_alpha, I_r);
assert_equals(pce_evaluate(r_i_alpha, I_r, xi), binfun(@plus, mu_r_i, r_i_k * pce_evaluate(r_k_alpha, I_r, xi)))

% Test without mean
r_i_alpha = kl_to_pce([], r_i_k, sigma_k, r_k_alpha, I_r);
assert_equals(pce_evaluate(r_i_alpha, I_r, xi), r_i_k * diag(sigma_k) * pce_evaluate(r_k_alpha, I_r, xi))

% Test with all parameters
r_i_alpha = kl_to_pce(mu_r_i, r_i_k, sigma_k, r_k_alpha, I_r);
assert_equals(pce_evaluate(r_i_alpha, I_r, xi), binfun(@plus, mu_r_i, r_i_k * diag(sigma_k) * pce_evaluate(r_k_alpha, I_r, xi)))
