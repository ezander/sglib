function unittest_kl_pce_compute_operator_fast
% UNITTEST_KL_PCE_COMPUTE_OPERATOR_FAST Test the KL_PCE_COMPUTE_OPERATOR_FAST function.
%
% Example (<a href="matlab:run_example unittest_kl_pce_compute_operator_fast">run</a>)
%   unittest_kl_pce_compute_operator_fast
%
% See also KL_PCE_COMPUTE_OPERATOR_FAST, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'kl_pce_compute_operator_fast' );

m_k=2; p_k=2; m_f=2; p_f=2; p_u=4; lex_sort=true;
[K,K_f]=compute_operators( m_k, p_k, m_f, p_f, p_u, lex_sort );
assert_equals( K, K_f );

m_k=2; p_k=2; m_f=2; p_f=2; p_u=4; lex_sort=false;
[K,K_f]=compute_operators( m_k, p_k, m_f, p_f, p_u, lex_sort );
assert_equals( K, K_f );

m_k=2; p_k=4; m_f=2; p_f=2; p_u=2; lex_sort=false;
[K,K_f]=compute_operators( m_k, p_k, m_f, p_f, p_u, lex_sort );
assert_equals( K, K_f );

m_k=2; p_k=4; m_f=2; p_f=2; p_u=2; lex_sort=true;
[K,K_f]=compute_operators( m_k, p_k, m_f, p_f, p_u, lex_sort );
assert_equals( K, K_f );

m_k=2; p_k=4; m_f=10; p_f=2; p_u=2; lex_sort=true;
[K,K_f]=compute_operators( m_k, p_k, m_f, p_f, p_u, lex_sort );
assert_equals( K, K_f );



function [K,K_f]=compute_operators( m_k, p_k, m_f, p_f, p_u, lex_sort )

% geometry and probability distributions will be will be the same for all
% test cases since it doesn't matter much
N=50;
[pos,els,bnd_nodes]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};

dist = gendist_create('beta', {2,4}, 'shift', 0.001);

stdnor_k=funcreate(@gendist_stdnor, @funarg, dist);
cov_k=funcreate(@exponential_covariance,@funarg, @funarg, 0.05, 1);

stdnor_f=funcreate(@gendist_stdnor, @funarg, dist);
cov_f=funcreate(@exponential_covariance,@funarg, @funarg, 0.05, 1);


% expand the field
[k_i_k,k_k_alpha,I_k]=expand_field_kl_pce( stdnor_k, cov_k, pos, G_N, p_k, m_k, 1 );
[f_i_k,f_k_alpha,I_f]=expand_field_kl_pce( stdnor_f, cov_f, pos, G_N, p_k, m_f, 1 );

[I_k,I_f,I_u]=multiindex_combine({I_k,I_f},p_u);
if lex_sort
    I_u=sortrows(I_u);
end

K=kl_pce_compute_operator(k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'tensor');
K_f=kl_pce_compute_operator_fast(k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'tensor');
