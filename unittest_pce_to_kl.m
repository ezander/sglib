function unittest_pce_to_kl
% UNITTEST_PCE_TO_KL Test the PCE_TO_KL function.
%
% Example (<a href="matlab:run_example unittest_pce_to_kl">run</a>)
%    unittest_pce_to_kl
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% we don't check directly the result here, but rather some properties
% 1. mean of KL is mean of PCE
% 2. spatial eigenfunctions are orthogonal with norm equal to KL
%    eigenvalues
% 3. stochastic eigenfunction (random vars) are orthogonal
% 4. we get the PCE back from the KL

N=51;
[pos,els]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );
p_kap=3;
m_kap=3;
M_kap=nchoosek( p_kap+m_kap, m_kap ); % full kl without truncation
l_kap=M_kap; % full kl without truncation
lc_kap=0.3;
stdnor_kap={@beta_stdnor,{4,2}};
cov_kap={@gaussian_covariance,{lc_kap,1}};
[kap_i_alpha, I_kap]=expand_field_pce_sg( stdnor_kap, cov_kap, [], pos, G_N, p_kap, m_kap );
[kap_i_0,kap_i_k,kap_k_alpha,relerr,sigma_k]=pce_to_kl( kap_i_alpha, I_kap, l_kap, G_N );


G_Phi=diag(multiindex_factorial(I_kap));

assert_equals( kap_i_0, kap_i_alpha(:,1), 'mean' );
assert_equals( kap_i_k'*G_N*kap_i_k, diag(sigma_k)^2, 'spat_orth' );
assert_equals( kap_k_alpha*G_Phi*kap_k_alpha', eye(M_kap), 'stoch_orth' );

kap2_i_alpha=kap_i_k*kap_k_alpha;
kap2_i_alpha(:,1)=kap_i_0;
assert_equals( kap2_i_alpha, kap_i_alpha, 'pce_back' );
