function K=kl_pce_compute_operator( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, form, varargin )
% KL_PCE_COMPUTE_OPERATOR Short description of kl_pce_compute_operator.
%   KL_PCE_COMPUTE_OPERATOR Long description of kl_pce_compute_operator.
%
% Example (<a href="matlab:run_example kl_pce_compute_operator">run</a>)
%
% See also

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

options=varargin2options( varargin );
[opt.verbosity,options]=get_option( options, 'verbosity', 0 );
[opt.twoarg_stiffness,options]=get_option( options, 'twoarg_stiffness', false );
check_unsupported_options( options, mfilename );

switch form
    case 'matrix'
        K=assemble_alpha_beta( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, opt );
    case 'tensor'
        K=assemble_mu_delta( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, opt );
    otherwise
        error('sglib:invalid', 'Invalid parameter value for KL/PDE form: %s. Use "matrix" or "tensor"', form);
end


function K=assemble_mu_delta( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, opt )
n=size(k_i_k,1);
l_k=size(k_i_k,2);
K_k=cell(l_k,1);
Delta_k=cell(l_k,1);
% tic; fprintf( 'comp_mat: ' );
% Delta=compute_pce_matrix( k_k_alpha, I_k, I_u, 'algorithm', 3 );
% toc
% tic; fprintf( 'comp_mat: ' );
Delta=compute_pce_matrix( k_k_alpha, I_k, I_u, 'algorithm', 4 );
% toc
% tic; fprintf( 'assem_stiif: ' );
for k=1:l_k
    if opt.twoarg_stiffness
        K_k{k}=operator_from_function( {stiffness_func, {k_i_k(:,k)}, {1}}, [n,n] );
    else
        K_k{k}=funcall( stiffness_func, k_i_k(:,k) );
    end
end
% toc
% tic; fprintf( 'coll_delta: ' );
for k=1:l_k
%    Delta_k{k}=sparse(Delta(:,:,k));
    Delta_k{k}=reshape(Delta(:,k), size(I_u,1), size(I_u,1) );
end
% toc
K=[K_k,Delta_k];



function K=assemble_alpha_beta( k_i_k, k_k_iota, I_k, I_u, stiffness_func, opt )
l_k=size(k_i_k,2);
K_k=cell(l_k,1);
for k=1:l_k
    K_k{k}=funcall( stiffness_func, k_i_k(:,k) );
end
N=size(K_k{1},1);

M_u=size(I_u,1);
K=cell(M_u,M_u);
for alpha=1:M_u
    if opt.verbosity
        m_alpha_u = size(M_u, 2);
        erase_print( '%d/%d %d/%d', alpha*(alpha+1)/2, m_alpha_u*(M_u+1)/2, alpha, M_u );
    end
    for beta=1:alpha
        h_k=k_k_iota*squeeze(hermite_triple_fast(I_u(alpha,:),I_u(beta,:),I_k(:,:)));
        % a1 B1 + a2 B2 + ... => C
        % r terms a NxN => NxN
        % NxrN * rNxN => NxN
        % [a1*I a2*I ...]*[B1; B2; ...]=a1*B1+a2*B2+...
        % kron( [a1*I a2*I ...]*[B1; B2; ...]=a1*B1+a2*B2+...
        K{alpha,beta}=kron( h_k', speye(N))*cell2mat(K_k);
        K{beta,alpha}=K{alpha,beta};
    end
end
if opt.verbosity
    erase_print();
end
K=cell2mat(K);
