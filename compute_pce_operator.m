function K=compute_pce_operator( k_i_iota, I_k, I_u, stiffness_func, form, variant )
% COMPUTE_PCE_MATRIX Compute the operator that represents multiplication with PC expanded random field.
%   K=COMPUTE_PCE_OPERATOR( K_I_IOTA, I_K, I_U, STIFFNESS_FUNC, FORM,
%   VARIANT) computes the PC multiplication operator where K_I_IOTA
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
%   The first can be in two variants (specified by VARIANT), where 1
%   specified the faster method and 2 the slower, but more intuitive (NOTE:
%   the faster method here is still pretty slow, need to implement the fast
%   method from compute_kl_pce_operator).
%
% Example (<a href="matlab:run_example compute_pce_operator">run</a>)
%   N=11;
%   p_k=3;
%   m_k=3;
%   stdnor_k={@beta_stdnor,{4,2}};
%   [els,pos,bnd]=create_mesh_1d( N, 0, 1 );
%   G_N=mass_matrix( els, pos );
%   lc_k=0.25;
%   cov_k={@gaussian_covariance,{lc_k,1}};
%   [k_i_iota, I_k]=expand_field_pce_sg( stdnor_k, cov_k, [], pos, G_N, p_k, m_k );
%   stiffness_func={@stiffness_matrix, {els, pos}, {1,2}};
%   I_u=I_k;
%   K=compute_pce_operator(  k_i_iota, I_k, I_u, stiffness_func, 'alpha_beta' )
%   clf; subplot(3,1,1); spy( K{1,1} );
%   subplot(3,1,2); spy( cell2mat(K) );
%   subplot(3,1,3); spy2( cellfun( @(Kab)(norm(Kab,1)~=0), K ) );

% See also COMPUTE_PCE_RHS, EXPAND_FIELD_PCE_SG

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin<6
    variant=1;
end
if nargin<5
    form='iota';
end

switch form
    case { 'alpha_beta' }
        switch variant
            case 1
                K=assemble_alpha_beta( k_i_iota, I_k, I_u, stiffness_func );
            case 2
                K=assemble_alpha_beta2( k_i_iota, I_k, I_u, stiffness_func );
        end
    case { 'alpha_beta_mat' }
        switch variant
            case 1
                K=cell2mat( assemble_alpha_beta( k_i_iota, I_k, I_u, stiffness_func ) );
            case 2
                K=cell2mat( assemble_alpha_beta2( k_i_iota, I_k, I_u, stiffness_func ) );
        end
    case { 'iota' }
        K=assemble_iota( k_i_iota, I_k, I_u, stiffness_func );
    otherwise
end


function K=assemble_iota( k_i_iota, I_k, I_u, stiffness_func )
m_iota_k=size(I_k,1);
K_iota=cell(m_iota_k,1);
for iota=1:m_iota_k
    K_iota{iota}=funcall( stiffness_func, k_i_iota(:,iota) );
end
K={K_iota;I_k;I_u};


function K=assemble_alpha_beta( k_i_iota, I_k, I_u, stiffness_func )
m_iota_k=size(I_k,1);
K_iota=cell(m_iota_k,1);
for iota=1:m_iota_k
    K_iota{iota}=funcall( stiffness_func, k_i_iota(:,iota) );
end

m_alpha_u=size(I_u,1);
K_ab=cell(m_alpha_u,m_alpha_u);
n=size(k_i_iota,1);
for alpha=1:m_alpha_u
    for beta=1:alpha
        K_ab{alpha,beta}=sparse(n,n);
        for iota=1:m_iota_k
            K_ab{alpha,beta}=K_ab{alpha,beta}+...
                hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(iota,:))*K_iota{iota};
        end
        K_ab{beta,alpha}=K_ab{alpha,beta};
    end
end
K=K_ab;


function K=assemble_alpha_beta2( k_i_iota, I_k, I_u, stiffness_func )
m_alpha_u=size(I_u,1);
K_ab=cell(m_alpha_u,m_alpha_u);
n=size(k_i_iota,1);
m_iota_k=size(I_k,1);
for alpha=1:m_alpha_u
    for beta=1:alpha
        k_ab=zeros(n,1);
        for iota=1:m_iota_k
            k_ab=k_ab+hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(iota,:))*k_i_iota(:,iota);
        end
        K_ab{alpha,beta}=funcall( stiffness_func, k_ab );
        K_ab{beta,alpha}=K_ab{alpha,beta};
    end
end
K=K_ab;
