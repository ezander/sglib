
rebuild=get_param('rebuild', false);
%autoloader( {'model_1d_large'; 'define_geometry'; 'discretize_model'; 'setup_equation'; 'solve_by_pcg'; 'vector_to_tensor'}, rebuild, 'caller' );
autoloader( {'model_1d_large'; 'define_geometry'; 'discretize_model'; 'setup_equation'}, rebuild, 'caller' );
rebuild=false;


[rho,flag]=simple_iteration_contractivity( Ki, Mi_inv,  'abstol', 1e-2 )

