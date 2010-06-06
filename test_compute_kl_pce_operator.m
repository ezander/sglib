function test_compute_kl_pce_operator



N=get_param( 'N', 50 );
[pos,els,bnd_nodes]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};

alphasort=true;
kfirst=false;

p_u=3;

stdnor_k={@gendist_stdnor, {'beta', {2,4}, 0.001, 1.0 }};
cov_k={@exponential_covariance,{0.05,1}};
%m_k=15; p_k=p_u; l_k=1;
m_k=10; p_k=p_u; l_k=1;

stdnor_f={@gendist_stdnor, {'beta', {2,4}, 0.001, 1.0 }};
cov_f={@exponential_covariance,{0.05,1}};
%m_f=25; p_f=p_u; l_f=1;
m_f=20; p_f=p_u; l_f=1;

I_u=multiindex(m_k+m_f, p_u );
I_ku=multiindex(m_k, p_u );
I_k=multiindex(m_k, p_k );

clc
size( I_u, 1 )
size( I_ku, 1 )
size( I_k, 1 )

%return
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
    I_u=sortrows(I_u);
end



tic
S=kl_pce_sparsity( I_u, I_k );
toc
multiplot_init(2,2)
multiplot; spy2(S)
multiplot; spy2(S); xlim([1,400]); ylim([1,400]);
multiplot; spy2(S); xlim([1,1000]); ylim([1,1000]);
multiplot; spy2(S); xlim([810,940]); ylim([810,940]);
%multiplot; spy2(S); xlim([2100,2130]); ylim([2100,2130]);
return

tic
Kf=kl_pce_compute_operator_fast(k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'tensor');
toc



multiplot
spy2(K{2,2})


multiplot
spy2(Kf{2,2})

multiplot
spy2(K{2,2}==Kf{2,2})
