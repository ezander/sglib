clear

addpath( 'dummy/' );


rf_filename='ranfield_so.mat';
reinit=true;
if ~reinit && exist( rf_filename, 'file' ) 
    load( rf_filename )
else
    % definition of the grid
    n=21;
    x=linspace(0,1,n)';
    x=x+0*0.4*(x(2)-x(1))*(rand(size(x))-0.5);
    els=[1:n-1; 2:n]';
    M=mass_matrix( els, x );

    % expansion of the parameter hand side field (k)
    big=false;
    if big
        p_k=4;
        m_gam_k=4;
        m_k=5;
    else
        p_k=2;
        m_gam_k=2;
        m_k=nchoosek(p_k+m_gam_k,m_gam_k);
    end
    lc_k=0.3;
    h_k={@beta_stdnor,{4,2}};
    cov_k={@gaussian_covariance,{lc_k,1}};
    options_expand_k.transform.correct_var=1;
    [k_iota, I_k]=expand_field_pce_sg( h_k, cov_k, [], x, M, p_k, m_gam_k, options_expand_k );
    %TODO: error if m_k>m_iota_k
    [mu_k,k_i_iota,v_k_i]=pce_to_kl( k_iota, I_k, M, m_k );
    %M=full(M);
    clear h_k cov_k M
    save( rf_filename, '-V6' );
end


m_gam_u=m_gam_k;
p_u=p_k;
I_u=multiindex( m_gam_u, p_u );
m_alpha_u=size(I_u,1);


% set u_alpha to something just to try wether K u_alpha will give the same
% for each operator representation
u_alpha=k_iota;
u_alpha=rand(size(k_iota));

% Assemble the stochastic operator via the PC expansion of k
stiffness_func={@stiffness_matrix, {els,x}, {1,2} };

K_ab=stochastic_operator_pce( k_iota, I_k, I_u, stiffness_func, 'alpha_beta', 1 );
f_beta_1=apply_stochastic_operator( K_ab, u_alpha );

K_ab_mat=stochastic_operator_pce( k_iota, I_k, I_u, stiffness_func, 'alpha_beta_mat' );
f_beta_2=apply_stochastic_operator( K_ab_mat, u_alpha );
fprintf( 'diff 1-2: %g\n', norm(f_beta_1-f_beta_2) );

K_ab2=stochastic_operator_pce( k_iota, I_k, I_u, stiffness_func, 'alpha_beta', 2 );
f_beta_2=apply_stochastic_operator( K_ab2, u_alpha );
fprintf( 'diff 1-2: %g\n', norm(f_beta_1-f_beta_2) );

K_ab2_mat=stochastic_operator_pce( k_iota, I_k, I_u, stiffness_func, 'alpha_beta', 2 );
f_beta_2=apply_stochastic_operator( K_ab2_mat, u_alpha );
fprintf( 'diff 1-2: %g\n', norm(f_beta_1-f_beta_2) );

K_iota_op=stochastic_operator_pce( k_iota, I_k, I_u, stiffness_func, 'iota' );
f_beta_3=apply_stochastic_operator( K_iota_op, u_alpha );
fprintf( 'diff 1-3: %g\n', norm(f_beta_1-f_beta_3) );

% Assemble the stochastic operator via the KL expansion of k
K_mu_delta=stochastic_operator_kl_pce( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, 'mu_delta', 1 );
f_beta_4=apply_stochastic_operator( K_mu_delta, u_alpha );
fprintf( 'diff 1-4: %g\n', norm(f_beta_1-f_beta_4) );

K_mu_iota=stochastic_operator_kl_pce( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, 'mu_iota', 1 );
f_beta_5=apply_stochastic_operator( K_mu_iota, u_alpha );
fprintf( 'diff 1-5: %g\n', norm(f_beta_1-f_beta_5) );

K_ab3=stochastic_operator_kl_pce( mu_k, v_k_i, k_i_iota, I_k, I_u, stiffness_func, 'alpha_beta', 1 );
f_beta_6=apply_stochastic_operator( K_ab3, u_alpha );
fprintf( 'diff 1-2: %g\n', norm(f_beta_1-f_beta_6) );


return

for i=1:21
    gam=randn(10000,m_gam_k);
    kernel_density( hermite_val_multi( f_pce(:,i), I_k, gam ), [], 0.02 );
    hold on;
    kernel_density( hermite_val_multi( f_kl(:,i), I_k, gam ), [], 0.02, 'r' );
    kernel_density( hermite_val_multi( f_ab(:,i), I_k, gam ), [], 0.02, 'g' );
    hold off;
    waitforbuttonpress;
end
