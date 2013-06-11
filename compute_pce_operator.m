function K=compute_pce_operator( k_i_iota, I_k, I_u, stiffness_func, form )
% COMPUTE_PCE_MATRIX Compute the operator that represents multiplication with PC expanded random field.
%   K=COMPUTE_PCE_OPERATOR( K_I_IOTA, I_K, I_U, STIFFNESS_FUNC, FORM) computes the PC multiplication operator where K_I_IOTA
%   represents the PC expansion of the parameter field in the operator
%   (e.g. the k(x,\omega) in the operator K u(x)=-div(k(x,\omega)grad
%   u(x)), and STIFFNESS_FUNC represents the assembly of the discrete
%   operator from one expansion function k_iota (i.e. k(x,\omega)=\sum
%   k_iota(x) H_iota(x)). I_K and I_U are the multiindex sets of the
%   parameter field K and the solution field U respectively, where I_U
%   should be some superset of I_K. The result can be in 3 different forms,
%   which can be specified by the string FORM: 
%     'alpha_beta': as cell array where K{alpha,beta} if the stiffness
%       matrix, corresponding to E(K*H_alpha*H_beta)
%     'alpha_beta_mat': as full matrix 
%     'iota': as cell array of stiffness matrices corresponding to E(k_iota)
%
% Example (<a href="matlab:run_example compute_pce_operator">run</a>)
%   N=11;
%   p_k=3;
%   m_k=3;
%   stdnor_k={@beta_stdnor,{4,2}};
%   [pos,els,bnd]=create_mesh_1d( 0, 1, N );
%   G_N=mass_matrix( pos, els );
%   lc_k=0.25;
%   cov_k={@gaussian_covariance,{lc_k,1}};
%   [k_i_iota, I_k]=expand_field_pce_sg( stdnor_k, cov_k, [], pos, G_N, p_k, m_k );
%   stiffness_func={@stiffness_matrix, {pos,els}, {1,2}};
%   I_u=I_k;
%   K=compute_pce_operator(  k_i_iota, I_k, I_u, stiffness_func, 'alpha_beta' )
%   clf; subplot(3,1,1); spy( K{1,1} );
%   subplot(3,1,2); spy( cell2mat(K) );
%   subplot(3,1,3); spy2( cellfun( @(Kab)(norm(Kab,1)~=0), K ) );

% See also COMPUTE_PCE_RHS, EXPAND_FIELD_PCE_SG

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin<5
    form='alpha_beta';
end

switch form
    case { 'alpha_beta' }
        K=assemble_alpha_beta( k_i_iota, I_k, I_u, stiffness_func );
    case { 'alpha_beta_mat' }
        K=assemble_alpha_beta( k_i_iota, I_k, I_u, stiffness_func );
        K=cell2mat( K );
    case { 'iota' }
        K=assemble_iota( k_i_iota, I_k, I_u, stiffness_func );
    otherwise
        error( 'compute_pce_operator:unkown_form', 'Unknown form: %s', form );
end

function K=assemble_alpha_beta( k_i_iota, I_k, I_u, stiffness_func )
m_u=size(I_u,1);
K=cell(m_u,m_u);
for alpha=1:m_u
    for beta=1:alpha
        k_ab=squeeze( tensor_multiply( hermite_triple_fast(I_u(alpha,:),I_u(beta,:),I_k), k_i_iota, 3, 2 ) );
        K{alpha,beta}=funcall( stiffness_func, k_ab );
        K{beta,alpha}=K{alpha,beta};
    end
end

function K=assemble_iota( k_i_iota, I_k, I_u, stiffness_func )
m_iota_k=size(I_k,1);
K_iota=cell(m_iota_k,1);
for iota=1:m_iota_k
    K_iota{iota}=funcall( stiffness_func, k_i_iota(:,iota) );
end
K={K_iota;I_k;I_u};


