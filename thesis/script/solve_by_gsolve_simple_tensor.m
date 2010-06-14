disp(' ');
maxit=100;
reltol=1e-6;

tic
Mi_inv=stochastic_preconditioner_deterministic(Ki);
toc

tic; fprintf( 'Solving (simple): \n' );
%[Ui,flag,info]=generalized_solve_simple_tensor( Ki,Fi,'reltol', reltol,'maxiter', maxit, 'Minv', Mi_inv, 'verbosity', inf);
opts={'eps', 1e-8, 'k_max', 100};
[Ui,flag,info,stats]=tensor_operator_solve_simple( Ki, Fi, 'Minv', Mi_inv, 'reltol', reltol, opts{:} );
toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

% vector_to_tensor;
% Ui_true=Ui;
% U_true=U;
