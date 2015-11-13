function unittest_kl_solve_1d_exp
% UNITTEST_KL_SOLVE_1D_EXP Test the KL_SOLVE_1D_EXP function.
%
% Example (<a href="matlab:run_example unittest_kl_solve_1d_exp">run</a>)
%   unittest_kl_solve_1d_exp
%
% See also KL_SOLVE_1D_EXP, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'kl_solve_1d_exp' );

[pos, els]=create_mesh_1d(2, 5, 201);
sig=2;
l_r=0.4;
[r_i_k, sigma_k] = kl_solve_1d_exp(pos, sig, l_r, 5);


G = mass_matrix(pos, els);
assert_matrix( r_i_k' * G * r_i_k, 'identity', 'r_is_orth', 'abstol', 1e-3);
C = covariance_matrix(pos, funcreate(@exponential_covariance, @funarg, @funarg, l_r, sig));

assert_equals(G*C*G*r_i_k, G*r_i_k*diag(sigma_k.^2), 'ev_eq', 'abstol', 0.02 );
