tic; fprintf( 'Creating matrix (%dx%d): ', prod(tensor_operator_size(Ki)) );
Ki_mat=tensor_operator_to_matrix(Ki);
toc
fi_vec=tensor_to_vector( Fi );


tic; fprintf( 'Solving: ', prod(tensor_operator_size(Ki)) );
ui_vec=Ki_mat\fi_vec;
toc

ui_mat=reshape( ui_vec, [], M );
[U_,S_,V_]=svd(ui_mat);
Ui={U_*S_,V_};

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
[u_i_k,u_k_alpha]=tensor_to_kl( U );
