fi_vec=tensor_to_vector( Fi );

use_pcg=get_param('use_pcg', true );
if ~use_pcg
    if ~exist('Ki_mat')
        tic; fprintf( 'Creating matrix (%dx%d): ', prod(tensor_operator_size(Ki)) );
        Ki_mat=tensor_operator_to_matrix(Ki);
        toc;
        
    end
    tic; fprintf( 'Solving (direct): ' );
    ui_vec=Ki_mat\fi_vec;
    toc;
else

    disp(' ');
    maxit=100;
    reltol=1e-6;

    Ki_fun=@(x)(tensor_operator_apply(Ki,x));
    Mi_inv=stochastic_preconditioner_deterministic(Ki);
    Mi_inv_fun=@(x)(tensor_operator_apply(Mi_inv,x));
    
    tic; fprintf( 'Solving (pcg): ' );
    [ui_vec,flag,info.relres,info.iter,resvec]=pcg(Ki_fun,fi_vec,reltol,maxit,Mi_inv_fun);
    toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

    tic; fprintf( 'Solving (gpcg): ' );
    [ui_vec2,flag,info]=generalized_solve_pcg( Ki,fi_vec,'reltol', reltol,'maxiter', maxit, 'Minv', Mi_inv);
    toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
end

ui_mat=reshape( ui_vec, [], M );
[U_,S_,V_]=svd(ui_mat);
Ui={U_*S_,V_};
Ui_true=Ui;


U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
U=tensor_truncate( U, 'eps', 1e-5 );
[u_i_k,u_k_alpha]=tensor_to_kl( U );
%[un_i_k,un_k_alpha]=tensor_to_kl( U, false );
