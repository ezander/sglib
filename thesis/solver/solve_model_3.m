%% Now apply the world-famous tensor product solver
% u_vec=apply_boundary_conditions_solution( u_vec_i, g_vec, P_I, P_B );
%[Ui,flag,relres,iter]=tensor_operator_solve_richardson( Ki, Fi, 'M', Mi );

underline( 'Tensor product PCG: ' );

vareps='fix';
trunc_mode=1;
%vareps=strcmp(eps_mode,'var');

trunc_options=struct();
trunc_options.k_max=30;
%trunc_options.eps=eps;
%trunc_options.relcutoff=true;
%if strcmp(orth_mode,'klm')
%    trunc_options.G={P_I*G_N*P_I', G_X};
%end

stats_gatherer=@pcg_gather_stats;
stats=struct();
stats.X_true=[];
%stats.trunc_options=trunc_options;
%stats.G={P_I*G_N*P_I', G_X};
stats.G=[];

reltol=1e-4;

Fi=tt_ktensor(Fi);
[Ui2,flag,info,stats]=tensor_operator_solve_pcg( Ki, Fi, 'M', Mi, 'reltol', reltol, 'truncate_options', trunc_options, 'vareps', vareps, 'trunc_mode', trunc_mode, 'stats_gatherer', stats_gatherer, 'stats', stats );
[Ui,I_u]=combine_dimensions( Ui, I_k, I_r )
%relerr=tensor_error( Ui, Ui2, true );
%ui_vec2=reshape(Ui2{1}*Ui2{2}',[],1);
%tensor_norm(tensor_add(Ui,Ui2,-1))/tensor_norm(Ui);

k=size(Ui2{1},2);
if eps>0
    R=relerr/eps;
else
    R=1;
end

U2=apply_boundary_conditions_solution( Ui2, G, P_I, P_B );
