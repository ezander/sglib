Fi_vec=tensor_to_vector( Fi );
Ki_fun=@(x)(tensor_operator_apply(Ki,x));
Mi_inv=stochastic_precond_mean_based(Ki);
Mi_inv_fun=@(x)(tensor_operator_apply(Mi_inv,x));

ws='caller';
solver_common_opts;
solver_stats_start

[Ui_vec,flag,info.relres,info.iter,resvec]=pcg(Ki_fun,Fi_vec,reltol,maxit,Mi_inv_fun);
G_vec=tensor_to_vector( G );
U_vec=apply_boundary_conditions_solution( Ui_vec, G_vec, P_I, P_B );

solver_stats_end
