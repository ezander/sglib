function test_solve_huge_model


rebuild=get_param('rebuild', false);
autoloader( {'model_huge'; 'define_geometry'; 'discretize_model'; 'setup_equation'; 'solve_by_gsolve_simple_tensor'}, rebuild, 'caller' );
rebuild=false;
