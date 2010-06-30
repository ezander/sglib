%% Now apply the world-famous tensor product solver
% u_vec=apply_boundary_conditions_solution( u_vec_i, g_vec, P_I, P_B );
%[Ui,flag,relres,iter]=tensor_operator_solve_richardson( Ki, Fi, 'M', Mi );

underline( 'Tensor product PCG: ' );

exponents=2:1:13;
reltol=1e-6;

for i=1:length(exponents)
    tolexp=exponents(i);
    if tolexp==14
        tol=0;
        truncate='eps 0';
    else
        tol=10^-tolexp;
        truncate=sprintf('eps 10^-%d', tolexp);
    end
    [Ui2,flag,relres,iter,info]=tensor_operator_solve_pcg( Ki, Fi, 'M', Mi, 'reltol', reltol, 'truncate_options', {'eps',tol, 'relcutoff', true}, 'true_sol', Ui );
    relerr=tensor_error( Ui2, Ui, 'relerr', true );
    k=tensor_rank( Ui2 );
    if tol>0
        R=relerr/tol;
    else
        R=1;
    end
    fprintf( 'truncate: %s:: flag: %d, relres: %g, iter: %d, relerr: %g k: %d, R: %g\n', truncate, flag, relres, iter, relerr, k, R );
    
    res(i).tolexp=tolexp;
    res(i).tol=tol;
    res(i).relerr=relerr;
    res(i).R=R;
    res(i).k=k;
    res(i).iter=iter;
    res(i).info=info;
    res(i).flag=flag;
end

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
[u_i_k, u_k_alpha]=tensor_to_kl( U );

