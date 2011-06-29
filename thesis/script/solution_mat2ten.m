[ui_i_k,ui_k_alpha]=pce_to_kl( Ui_mat, I_u, inf, [], [] );
Ui=kl_to_tensor(ui_i_k, ui_k_alpha);
Ui=tensor_truncate( Ui, 'eps', 1e-14 );

[u_i_k,u_k_alpha]=pce_to_kl( U_mat, I_u, inf, [], [] );
U=kl_to_tensor(u_i_k, u_k_alpha);
U=tensor_truncate( U, 'eps', 1e-14 );

Ui_true=Ui;
U_true=U;
