function operators
global n pos els M %#ok
global p_f m_gam_f m_f lc_f h_f cov_f f_alpha I_f mu_f f_k_alpha f_i_k %#ok
global p_k m_gam_k m_k lc_k h_k cov_k k_alpha I_k mu_k k_k_alpha k_i_k %#ok
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
    K_ab=kl_pce_compute_operator( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'matrix' );
    toc
    tic
    K_mu_delta=kl_pce_compute_operator( k_i_k, k_k_alpha, I_k, I_u, stiffness_func, 'tensor' );
    toc
    save( rf_filename, 'K_*', '-V6' );
end

%%
