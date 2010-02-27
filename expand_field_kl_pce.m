function [r_i_k,r_k_alpha,I_r]=expand_field_kl_pce( r_stdnor_func, cov_r_func,  pos, G_N, p_r, m_r, l_r, varargin )

% cov_gam_func, from options

[r_i_alpha, I_r]=expand_field_pce_sg( r_stdnor_func, cov_r_func, cov_gam_func, pos, G_N, p_r, m_r );

if true
    C=covariance_matrix( pos, cov_r_func );
    v_r_i=kl_solve_evp( C, G_N, l_r );
    [r_i_k,r_k_alpha]=project_pce_on_kl( r_i_alpha, I_r, v_r_i );
else
    [r_i_k,r_k_alpha]=pce_to_kl( r_i_alpha, I_r, l_r, G_N );
end

