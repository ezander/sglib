clear

N=get_param( 'N', 50 );
[pos,els,bnd_nodes]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};

alphasort=true;
alphasort=true;
kfirst=false;

p_u=2;

stdnor_k={@gendist_stdnor, {'beta', {2,4}, 0.001, 1.0 }};
cov_k={@exponential_covariance,{0.05,1}};
m_k=7; p_k=2*p_u; l_k=1;

stdnor_f={@gendist_stdnor, {'beta', {2,4}, 0.001, 1.0 }};
cov_f={@exponential_covariance,{0.05,1}};
m_f=3; p_f=2; l_f=1;


% expand the field
[k_i_k,k_k_alpha,I_k,l_k]=expand_field_kl_pce( stdnor_k, cov_k, pos, G_N, p_k, m_k, l_k );
[f_i_k,f_k_alpha,I_f,l_f]=expand_field_kl_pce( stdnor_f, cov_f, pos, G_N, p_k, m_f, l_f );

verbose=get_param( 'verbose', true );

if kfirst
    [I_k,I_f,I_u]=multiindex_combine({I_k,I_f},p_u);
else
    [I_f,I_k,I_u]=multiindex_combine({I_f,I_k},p_u);
end
if alphasort
    I_k=sortrows(I_k);
    I_f=sortrows(I_f);
    I_u=sortrows(I_u);
end

tic
K=kl_pce_compute_operator_fast(k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'tensor');
toc

S=kl_pce_sparsity( I_u, I_k );

subplot(2,1,1)
spy(K{2,2})

subplot(2,1,2)
spy(S)

