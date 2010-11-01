%clear

%% 1. Define the geometry
geom='lshape';
num_refine=2;
show_mesh=false;
[pos,els,G_N,ptdata]=load_pdetool_geom( geom, 'numrefine', num_refine, 'showmesh', show_mesh );
[d,N]=size(pos);

multiplot_init(2,2);
for i=1:2
    %% 2.2 Define the covariance
    cov_k_handle=@exponential_covariance;
    if i==1
        lc_k=[0.1 0.4];
    else
        lc_k=0.4; %[0.1 0.4];
    end
    cov_k_func={cov_k_handle, {lc_k,1}};
    
    %% 2.3 Check the KL convergence
    C_k=covariance_matrix( pos, cov_k_func );
    [k_i_k,sigma_k_k]=kl_solve_evp( C_k, G_N, 40 );
    [kl_rem,params,sigma_ex]=kl_estimate_eps( sigma_k_k, 'Nout', 100, 'full', true );
    kl_rem_old=kl_rem;
    sigma_k_k_old=sigma_k_k;
    
    %%
    eps_k=0.05;
    l_k=find(kl_rem<=eps_k,1,'first');
    m_k=l_k;
    [k_i_alpha, I_k]=expand_gaussian_field_pce( cov_k_func, pos, G_N, m_k );
    
    multiplot; plot( sigma_ex ); plot( sigma_k_k ); plot(kl_rem(1:100)); ylim([0,1])

    [k_i_k,sigma_k_k]=kl_solve_evp( C_k, G_N, 400 );
    [kl_rem2,params,sigma_ex]=kl_estimate_eps( sigma_k_k, 'Nout', 400, 'full', true );

    
    multiplot; plot(kl_rem(1:400)); plot(kl_rem2(1:400)); 
end
