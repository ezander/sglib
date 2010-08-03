function show_model_data( model )
autoloader( loader_scripts( model ), false, 'caller' );
pos(2,:)=-pos(2,:); % invert y axis for display
display_model_details
show_mesh_and_sample( model, pos, els, f_i_k, f_k_alpha, I_f )
