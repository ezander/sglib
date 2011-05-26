function disp_model_data( model )
autoloader( loader_scripts( model ), false, 'caller' );
pos(2,:)=-pos(2,:); % invert y axis for display
display_model_details
