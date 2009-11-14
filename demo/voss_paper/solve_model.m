%% Now apply the world-famous tensor product solver
% u_vec=apply_boundary_conditions_solution( u_vec_i, g_vec, P_I, P_B );
%[Ui,flag,relres,iter]=tensor_operator_solve_richardson( Ki, Fi, 'M', Mi );

underline( 'Tensor product PCG: ' );

vareps=strcmp(eps_mode,'var');
trunc_mode;

truncate_options.eps=eps;
truncate_options.relcutoff=true;
if strcmp(orth_mode,'klm')
    G_X=spdiags(multiindex_factorial(I_u),0,M,M);
    truncate_options.G1=P_I*G_N*P_I';
    truncate_options.G2=G_X;
end

[Ui2,flag,relres,iter,info]=tensor_operator_solve_pcg( Ki, Fi, 'M', Mi, 'reltol', reltol, 'truncate_options', truncate_options, 'true_sol', Ui, 'vareps', vareps, 'trunc_mode', trunc_mode );
ui_vec2=reshape(Ui2{1}*Ui2{2}',[],1);
relerr=tensor_norm(tensor_add(Ui,Ui2,-1))/tensor_norm(Ui);
%relerr-relerr2
k=size(Ui2{1},2);
if eps>0
    R=relerr/eps;
else
    R=1;
end
rank=size(Ui2,2);
%fprintf( 'truncate: %s:: flag: %d, relres: %g, iter: %d, relerr: %g ... k:
%%d, R: %g\n', eps, flag, relres, iter, relerr, k, R ); 

U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
[mu_u_i, u_i_k, u_k_alpha]=tensor_to_kl( U );
