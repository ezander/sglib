function K=load_kl_operator( name, version, silent, mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type )

%types={'alpha_beta', 'mu_delta', 'mu_iota' };

op_filename=[name '.mat'];
K=load_or_recompute(...
    1, ...
    @compute_operator_kl,...
    { mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type }, ...
    op_filename, ...
    version );
K=K{1};


function K=compute_operator_kl( mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type );
global show_timings
if show_timings; tic; end
K=stochastic_operator_kl_pce( mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type );
if show_timings; toc; end

    