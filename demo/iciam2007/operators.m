function operators
global n pos els M %#ok
global p_f m_gam_f m_f lc_f h_f cov_f f_alpha I_f mu_f f_i_alpha v_f %#ok
global p_k m_gam_k m_k lc_k h_k cov_k k_alpha I_k mu_k k_i_alpha v_k %#ok
global p_u m_gam_u I_u %#ok

global K_ab K_mu_delta K_mu_iota %#ok
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};

rf_filename='operator_kl_smd.mat';
reinit=false;
%reinit=true;
if ~reinit && exist( rf_filename, 'file' ) 
    load( rf_filename )
else
    tic
    K_ab=compute_kl_pce_operator( mu_k, v_k, k_i_alpha, I_k, I_u, stiffness_func, 'alpha_beta' );
    toc
    tic
    K_mu_delta=compute_kl_pce_operator( mu_k, v_k, k_i_alpha, I_k, I_u, stiffness_func, 'mu_delta' );
    toc
    tic
    K_mu_iota=compute_kl_pce_operator( mu_k, v_k, k_i_alpha, I_k, I_u, stiffness_func, 'mu_iota' );
    toc
    save( rf_filename, 'K_*', '-V6' );
end

%%
