[u_i_k, u_k_alpha]=tensor_to_kl( U, false );
pce_func1={@kl_pce_field_realization, {u_i_k, u_k_alpha, I_u}, {1,2,3}};
pce_func2={@kl_pce_solve_system, {k_i_k, k_k_alpha, I_k, f_i_k, f_k_alpha, I_f, g_i_k, g_k_alpha, I_g, stiffness_func, P_I, P_B}, {1,2,3,4,5,6,7,8,9,10,11,12} };
m=size(I_u,2);
randn('seed',1010);
info.errest_l2=pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1, 'G', [] );
info.errest_L2=pce_error_mc( pce_func1, pce_func2, m, 'num_mc', 100, 'block', 1, 'G', G_N );
