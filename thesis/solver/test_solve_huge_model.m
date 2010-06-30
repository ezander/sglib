%function test_solve_huge_model
clc
format compact
format short g


rebuild=get_param('rebuild', false);
autoloader( {'model_huge'; 'define_geometry'; 'discretize_model'; 'setup_equation'; 'do_solve_huge_model_simple'}, rebuild, 'caller' );
rebuild=false;


%%
prod(tensor_size(Fi))
Ui_vec_tens=tensor_to_vector(X);
Fi_vec=tensor_to_vector( Fi );

%%
Ki_fun=@(x)(tensor_operator_apply(Ki,x));
Mi_inv=stochastic_preconditioner_deterministic(Ki);
Mi_inv_fun=@(x)(tensor_operator_apply(Mi_inv,x));

maxit=100;
reltol=1e-6;

tic; fprintf( 'Solving (pcg): ' );
[Ui_vec_pcg6,flag,info.relres,info.iter,resvec]=pcg(Ki_fun,Fi_vec,reltol,maxit,Mi_inv_fun);
toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

%%
maxit=100;
reltol=1e-2;

tic; fprintf( 'Solving (pcg): ' );
[Ui_vec_pcg2,flag,info.relres,info.iter,resvec]=pcg(Ki_fun,Fi_vec,reltol,maxit,Mi_inv_fun);
toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

%%

gvector_error( Ui_vec_pcg2, Ui_vec_pcg6, [], true )
gvector_error( Ui_vec_tens, Ui_vec_pcg6, [], true )
%%
R_vec_pcg6=operator_apply( Ki, Ui_vec_pcg6, 'residual', true, 'b', Fi_vec );
gvector_norm( R_vec_pcg6 )/gvector_norm(Fi_vec)

R_vec_pcg2=operator_apply( Ki, Ui_vec_pcg2, 'residual', true, 'b', Fi_vec );
gvector_norm( R_vec_pcg2 )/gvector_norm(Fi_vec)

%%
tic
R_vec_tens=operator_apply( Ki, Ui_vec_tens, 'residual', true, 'b', Fi_vec );
gvector_norm( R_vec_tens )/gvector_norm(Fi_vec)
toc

