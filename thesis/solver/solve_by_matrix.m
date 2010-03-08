if ~exist('Ki_mat')
    tic; fprintf( 'Creating matrix (%dx%d): ', prod(tensor_operator_size(Ki)) );
    Ki_mat=tensor_operator_to_matrix(Ki);
    toc
    fi_vec=tensor_to_vector( Fi );
end

use_pcg=get_param('use_pcg', false );
tic; 
if ~use_pcg
    fprintf( 'Solving (direct): ', prod(tensor_operator_size(Ki)) );
    ui_vec=Ki_mat\fi_vec;
else
    fprintf( 'Solving (pcg): ', prod(tensor_operator_size(Ki)) );
    %[ui_vec,flag,info.relres,info.iter]=pcg(Ki_mat,fi_vec);
    disp(' ');
    maxit=100;
    reltol=1e-3;
    tol=reltol*norm(fi_vec);
    [ui_vec,flag,info.relres,info.iter]=pcg(Ki_mat,fi_vec,tol,maxit);
    fprintf( 'Flag: %d, iter: %d, relres: %g\n', flag, info.iter, info.relres );

    Ki_fun=@(x)(tensor_operator_apply(Ki,x));
    [ui_vec,flag,info.relres,info.iter]=pcg(Ki_fun,fi_vec,tol,maxit);
    fprintf( 'Flag: %d, iter: %d, relres: %g\n', flag, info.iter, info.relres );

    Mi=stochastic_preconditioner_deterministic(Ki);
    Mi_fun=@(x)(tensor_operator_apply(Mi,x));
    [ui_vec,flag,info.relres,info.iter]=pcg(Ki_fun,fi_vec,tol,maxit,Mi_fun);
    fprintf( 'Flag: %d, iter: %d, relres: %g\n', flag, info.iter, info.relres );
    
end
toc

ui_mat=reshape( ui_vec, [], M );
[U_,S_,V_]=svd(ui_mat);
Ui={U_*S_,V_};
Ui_true=Ui;


U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
U=tensor_truncate( U );
[u_i_k,u_k_alpha]=tensor_to_kl( U );
%[un_i_k,un_k_alpha]=tensor_to_kl( U, false );
