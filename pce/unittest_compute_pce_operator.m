function unittest_compute_pce_operator
% UNITTEST_COMPUTE_PCE_OPERATOR Test the COMPUTE_PCE_OPERATOR function.
%
% Example (<a href="matlab:run_example unittest_compute_pce_operator">run</a>)
%   unittest_compute_pce_operator
%
% See also COMPUTE_PCE_OPERATOR 

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


munit_set_function( 'pce_multiply' );

N=4;
[pos,els]=create_mesh_1d( 0, 1, N );
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};

k00=[1;1;1;1];
k11=[1;2;3;4];
k32=[7;2;1;3];

I_k=[0 0; 1 1; 3 2];
k_i_iota=[ k00 k11 k32 ];
I_u=I_k;
K00=stiffness_matrix(pos, els, k00 );
K11=stiffness_matrix(pos, els, k11 );
K32=stiffness_matrix(pos, els, k32 );

% test alpha_beta form
K=compute_pce_operator(  k_i_iota, I_k, I_u, stiffness_func, 'alpha_beta' );

assert_equals( size(K), [3,3], 'size' );
assert_equals( size(K{1,1}), [4,4], 'size_1' );

% K{i,j} must be SUM_l c(I_k(i),I_k(j),I_k(l))*K_l
assert_equals( K{1,1}, 1*K00+0*K11+0*K32,   'K11' );
assert_equals( K{1,2}, 0*K00+1*K11+0*K32,   'K12' );
assert_equals( K{1,3}, 0*K00+0*K11+6*2*K32, 'K13' );

assert_equals( K{2,1}, 0*K00+1*K11+0*K32, 'K21' );
assert_equals( K{2,2}, 1*K00+0*K11+0*K32, 'K22' );
assert_equals( K{2,3}, 0*K00+0*K11+0*K32, 'K23' );

assert_equals( K{3,1}, 0*K00+0*K11+6*2*K32, 'K31' );
assert_equals( K{3,2}, 0*K00+0*K11+0*K32,   'K32' );
assert_equals( K{3,3}, 6*2*K00+0*K11+0*K32, 'K33' );


% test alpha_beta_mat form
K=compute_pce_operator(  k_i_iota, I_k, I_u, stiffness_func, 'alpha_beta_mat' );

assert_equals( size(K), [12,12], 'size' );
assert_equals( K, [K00 K11 12*K32; K11 K00 zeros(4); 12*K32 zeros(4) 12*K00],   'Kmat' );


% test alpha_beta_mat form
K=compute_pce_operator(  k_i_iota, I_k, I_u, stiffness_func, 'iota' );

assert_equals( size(K), [3,1], 'size' );
assert_equals( size(K{1}), [3,1], 'size' );
assert_equals( K{2}, I_u, 'I_a' );
assert_equals( K{3}, I_u, 'I_b' );
assert_equals( K{1}{1}, K00, 'K00' );
assert_equals( K{1}{2}, K11, 'K11' );
assert_equals( K{1}{3}, K32, 'K32' );
