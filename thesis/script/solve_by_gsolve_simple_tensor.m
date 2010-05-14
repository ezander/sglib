Fi_vec=tensor_to_vector( Fi );

disp(' ');
maxit=100;
reltol=1e-6;

Mi_inv=stochastic_preconditioner_deterministic(Ki);

tic; fprintf( 'Solving (simple): \n' );
[Ui,flag,info]=generalized_solve_simple_tensor( Ki,Fi,'reltol', reltol,'maxiter', maxit, 'Minv', Mi_inv, 'debug_level', inf);
toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

% vector_to_tensor;
% Ui_true=Ui;
% U_true=U;
