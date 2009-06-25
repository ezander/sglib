%% Now apply the world-famous tensor product solver
% u_vec=apply_boundary_conditions_solution( u_vec_i, g_vec, P_I, P_B );
%[Ui,flag,relres,iter]=tensor_operator_solve_richardson( Ki, Fi, 'M', Mi );

underline( 'Tensor product PCG: ' );

for tolexp=1:8
    if tolexp==8
        tol=0;
        truncate='eps 0';
    else
        tol=10^-tolexp;
        truncate=sprintf('eps 10^-%d', tolexp);
    end
    [Ui,flag,relres,iter,info]=tensor_operator_solve_pcg( Ki, Fi, 'M', Mi, 'truncate_options', {'eps',tol, 'relcutoff', true} );
    ui_vec3=reshape(Ui{1}*Ui{2}',[],1);
    relerr=norm(ui_vec-ui_vec3 )/norm(ui_vec);
    k=size(Ui{1},2);
    if tol>0
        R=relerr/tol;
    else
        R=1;
    end
    fprintf( 'truncate: %s:: flag: %d, relres: %g, iter: %d, relerr: %g k: %d, R: %g\n', truncate, flag, relres, iter, relerr, k, R );
    
    res(tolexp).tolexp=tolexp;
    res(tolexp).tol=tol;
    res(tolexp).relerr=relerr;
    res(tolexp).R=R;
    res(tolexp).k=k;
    res(tolexp).iter=iter;
    res(tolexp).info=info;
end

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
[mu_u_i, u_i_k, u_k_alpha]=tensor_to_kl( U );

