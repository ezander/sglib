function unittest_kl_pce_compute_operator
% UNITTEST_KL_PCE_COMPUTE_OPERATOR Test the KL_PCE_COMPUTE_OPERATOR function.
%
% Example (<a href="matlab:run_example unittest_kl_pce_compute_operator">run</a>)
%   unittest_kl_pce_compute_operator
%
% See also KL_PCE_COMPUTE_OPERATOR, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'kl_pce_compute_operator' );

N=20;
[pos,els]=create_mesh_1d( 0, 1, 20 );
stiffness_func={@stiffness_matrix, {pos,els}, {1,2}};
stiffness_func2={@compute_stiffness, {pos,els}, {1,2}};

I_u=multiindex(2,3);
M_u=size(I_u,1);
I_k=multiindex(2,4);
M_k=size(I_k,1);
l_k=3;

k_i_k=rand(N,l_k);
k_k_alpha=rand(l_k,M_k);

K=kl_pce_compute_operator( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'tensor' );
assert_equals( size(K), [3,2], 'size' );
assert_equals( K{1,1}, stiffness_matrix(pos,els,k_i_k(:,1)), 'K_0' );
assert_equals( K{3,1}, stiffness_matrix(pos,els,k_i_k(:,3)), 'K_2' );
assert_equals( K{2,2}, compute_pce_matrix(k_k_alpha(2,:), I_k, I_u), 'Delta_1' );


K2=kl_pce_compute_operator( k_i_k, k_k_alpha, I_k, I_u, stiffness_func2, 'tensor', 'twoarg_stiffness', true );
assert_equals( size(K2), [3,2], 'size' );
assert_true( iscell(K2{1,1}), 'must be an operator', 'K_0_func' );
assert_equals( operator_size(K2{1,1}), size(K{1,1}), 'K_0_size' );
assert_equals( K2{2,2}, K{2,2}, 'Delta_1' );
u=rand(N*M_u,1);
assert_equals( tensor_operator_apply( K2, u ), tensor_operator_apply( K, u ), 'same_result' )

Kmat=kl_pce_compute_operator( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'matrix' );
assert_equals( size(Kmat), [N*M_u,N*M_u], 'mat_size' );
assert_equals( Kmat*u, tensor_operator_apply( K, u ), 'mat_same_result' )



function v=compute_stiffness( pos, els, k, u )
K=stiffness_matrix( pos, els, k );
v=K*u;



