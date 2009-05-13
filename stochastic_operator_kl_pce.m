function K=stochastic_operator_kl_pce( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, form, variant, varargin )

options=varargin2options( varargin{:} );
[silent,options]=get_option( options, 'silent', false );
[show_timings,options]=get_option( options, 'show_timings', true );
[use_waitbar,options]=get_option( options, 'use_waitbar', true );
check_unsupported_options( options, mfilename );


if nargin<8 || isempty( variant )
    variant=1;
end
if nargin<7 || isempty( form )
    form='mu_delta';
end

opt.silent=silent;
opt.show_timings=show_timings;
opt.use_waitbar=use_waitbar;

switch form
    case { 'alpha_beta' }
        K=assemble_alpha_beta( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, opt );
    case { 'alpha_beta_mat' }
        K=cell2mat( assemble_alpha_beta( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, opt ) );
    case { 'mu_delta' }
        K=assemble_mu_delta( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, opt );
    case { 'mu_iota' }
        K=assemble_mu_iota( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, opt );
    otherwise
end


function K_mu_delta=assemble_mu_delta( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, opt )
K_mu=funcall( stiffness_func, mu_k );
m_k=size(v_k_i,2);
K_i=cell(m_k,1);
Delta_i=cell(m_k,1);
m_iota_k=size(k_i_iota,2);
for i=1:m_k
    erase_print( 'assemble: %d/%d', i, m_k );
    K_i{i}=funcall( stiffness_func, v_k_i(:,i) );
    Delta_i{i}=stochastic_pce_matrix( k_i_iota(i,:), I_k, I_u );
end
erase_print();
Delta_mu=stochastic_pce_matrix( [1,zeros(1,m_iota_k-1)], I_k, I_u );
K_mu_delta={K_mu; Delta_mu; K_i; Delta_i };

function K_mu_iota=assemble_mu_iota( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, opt )
K_mu=funcall( stiffness_func, mu_k );
m_k=size(v_k_i,2);
K_i=cell(m_k,1);
for i=1:m_k
    erase_print( 'assemble: %d/%d', i, m_k );
    K_i{i}=funcall( stiffness_func, v_k_i(:,i) );
end
erase_print();
K_mu_iota={K_mu; K_i; k_i_iota; I_u; I_k };


function K_ab=assemble_alpha_beta( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, opt )
K_mu=funcall( stiffness_func, mu_k );
m_k=size(v_k_i,2);
K_i=cell(m_k,1);
for i=1:m_k
    K_i{i}=funcall( stiffness_func, v_k_i(:,i) );
end
m_iota_k=size(I_k,1);

hermite_triple_fast( max([I_u(:);I_k(:)] ) );
m_alpha_u=size(I_u,1);
K_ab=cell(m_alpha_u,m_alpha_u);
for alpha=1:m_alpha_u
    erase_print( '%d/%d %d/%d', alpha*(alpha+1)/2, m_alpha_u*(m_alpha_u+1)/2, alpha, m_alpha_u );
    for beta=1:alpha
        K_ab{alpha,beta}=hermite_triple_fast(I_u(alpha,:),I_u(beta,:),I_k(1,:))*K_mu;
        for i=1:m_k
            h_i=k_i_iota(i,:)*hermite_triple_fast(I_u(alpha,:),I_u(beta,:),I_k(:,:));
            K_ab{alpha,beta}=K_ab{alpha,beta}+h_i*K_i{i};
        end
        K_ab{beta,alpha}=K_ab{alpha,beta};
    end
    fprintf( repmat(sprintf('\b'), length(s), 1) );
end
erase_print();
