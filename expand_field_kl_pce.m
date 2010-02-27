function [mu_r_i,r_i_k,r_k_alpha,I_r]=expand_field_kl_pce( rho_stdnor_func, cov_r_func, cov_gam_func, pos, G_N, p, m_gam, l_r, varargin )

[r_i_alpha, I_r]=expand_field_pce_sg( rho_stdnor_func, cov_r_func, cov_gam_func, pos, G_N, p, m_gam, varargin{:} );
[mu_r_i,r_i_k,r_k_alpha]=pce_to_kl( r_i_alpha, I_r, l_r, G_N );
