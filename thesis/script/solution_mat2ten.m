[ui_i_k,ui_k_alpha]=pce_to_kl( Ui_mat, I_u, inf, [], [] );
Ui=kl_to_tensor(ui_i_k, ui_k_alpha);
Ui=tensor_truncate( Ui, 'eps', 1e-14 );
U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );

Ui_true=Ui;
U_true=U;

