function unittest_kl_solve_evp
% UNITTEST_KL_SOLVE_EVP Test the KL_SOLVE_EVP function.
%
% Example (<a href="matlab:run_example unittest_kl_solve_evp">run</a>)
%    unittest_kl_solve_evp
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'kl_solve_evp' );

[pos,els]=create_mesh_1d(0,1,11);
C=covariance_matrix( pos, {@gaussian_covariance, {0.3, 2}} );
M=mass_matrix( pos, els );

[f,s]=kl_solve_evp( C, [], 3 );
assert_equals( size(f), [11,3] );
assert_equals( f'*f, eye(3) );
assert_equals( f'*C*f, diag(s.^2) );

[f,s]=kl_solve_evp( C, M, 4 );
assert_equals( size(f), [11,4] );
assert_equals( f'*M*f, eye(4) );
assert_equals( f'*M*C*M*f, diag(s.^2) );

fs=kl_solve_evp( C, [], 5, 'correct_var', true );
assert_equals( size(fs), [11,5] );
assert_equals( diag(fs*fs'), diag(C) );

fs=kl_solve_evp( C, M, 5, 'correct_var', true );
assert_equals( size(fs), [11,5] );
assert_equals( diag(fs*fs'), diag(C) );



%% check against values for the exponential covariance taken from 
% ghanem & spanos, implemented in kl_solve_1d_exp
a=3;
c=0.7;
[pos,els]=create_mesh_1d(-a,a,200);
C=covariance_matrix( pos, {@exponential_covariance, {c, 1}} );
M=mass_matrix( pos, els );
[v,sig]=kl_solve_evp( C, M, 10 );
v = binfun(@times, v, sign(v(1,:)));

[v_ex, sig_ex]=kl_solve_1d_exp( pos, 1, c, 10 );
v_ex = binfun(@times, v_ex, sign(v_ex(1,:)));

assert_equals( sig, sig_ex, 'exp_cov_1d', 'abstol', 1e-3 );
assert_equals( v, v_ex, 'exp_cov_1d_v', 'abstol', 1e-2 );

[~,sig]=kl_solve_evp( C, M, 199 );
assert_equals( sum(sig.^2), 2*a, 'sum_sig2', 'abstol', 1e-1 );

