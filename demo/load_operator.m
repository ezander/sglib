function varargout=load_kl_operator( name, version, silent, params, types )

types={'alpha_beta', 'mu_delta', 'mu_iota' };

for type=types
    op_filename=[name '-' type '.mat'];
    output_args=load_or_recompute(...
        1, ...
        @compute_operator_kl,...
        { mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type }, ...
        op_filename, ...
        version );
    [mu_r_j,rho_i_alpha,r_i_j, I_r]=output_args{:};
end


function K=compute_operator_kl( mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type );
global show_timings
if show_timings; tic; end
K=stochastic_operator_kl_pce( mu_r_j, r_i_j, rho_i_alpha, I_r, I_u, stiffness_func, type );
if show_timings; toc; end

    