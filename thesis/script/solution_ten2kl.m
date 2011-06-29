Ui=tensor_truncate( U, 'eps', 1e-14 );
[ui_i_k,ui_k_alpha]=tensor_to_kl( Ui );
U=tensor_truncate( U, 'eps', 1e-14 );
[u_i_k,u_k_alpha]=tensor_to_kl( U );
