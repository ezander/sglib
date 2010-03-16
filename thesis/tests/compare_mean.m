% Suppress warnings about not used variables and not preallocated arrays
%#ok<*NASGU>
%#ok<*AGROW>

rebuild=get_param('rebuild', true);
autoloader( {'model_large'; 'discretize_model'; 'setup_equation'; 'solve_by_pcg'}, rebuild );
rebuild=false;


% get solution via kl_pce field of solution u(x,xi)
u=kl_pce_moments( u_i_k, u_k_alpha, I_u );


% get solution via solving the system with k(x,xi), f(x,xi) and g(x,xi) for
% the same xi as above
k=kl_pce_moments( k_i_k, k_k_alpha, I_k );
f=kl_pce_moments( f_i_k, f_k_alpha, I_f );
g=kl_pce_moments( g_i_k, g_k_alpha, I_g );

K=funcall( stiffness_func, k );
Ki=apply_boundary_conditions_operator( K, P_I );
fi=apply_boundary_conditions_rhs( K, f, g, P_I, P_B );
ui=Ki\fi;
u2=apply_boundary_conditions_solution( ui, g, P_I, P_B );

% plot solutions fields and difference
subplot(3,1,1); plot_field(pos, els, u ); colorbar;
subplot(3,1,2); plot_field(pos, els, u2 ); colorbar;
subplot(3,1,3); plot_field(pos, els, u-u2 ); colorbar;
