Fi_vec=tensor_to_vector( Fi );

disp(' ');
maxit=100;
reltol=1e-6;

Ki_fun=@(x)(tensor_operator_apply(Ki,x));
Mi_inv=stochastic_preconditioner_deterministic(Ki);
Mi_inv_fun=@(x)(tensor_operator_apply(Mi_inv,x));

tic; fprintf( 'Solving (pcg): ' );
[Ui_vec,flag,info.relres,info.iter,resvec]=pcg(Ki_fun,Fi_vec,reltol,maxit,Mi_inv_fun);
toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
Ui=reshape( Ui_vec, tensor_size(Fi) );