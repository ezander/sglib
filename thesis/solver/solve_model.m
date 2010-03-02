%% Now apply the world-famous tensor product solver
% u_vec=apply_boundary_conditions_solution( u_vec_i, g_vec, P_I, P_B );
%[Ui,flag,relres,iter]=tensor_operator_solve_richardson( Ki, Fi, 'M', Mi );

underline( 'Tensor product PCG: ' );

vareps=strcmp(eps_mode,'var');
trunc_mode;

trunc_options.eps=eps;
trunc_options.relcutoff=true;
if strcmp(orth_mode,'klm')
    trunc_options.G={P_I*G_N*P_I', G_X};
end

stats_gatherer=@pcg_gather_stats;
stats=struct();
stats.X_true=Ui;
stats.trunc_options=trunc_options;
stats.G={P_I*G_N*P_I', G_X};

[Ui2,flag,info,stats]=tensor_operator_solve_pcg( Ki, Fi, 'M', Mi, 'reltol', reltol, 'truncate_options', trunc_options, 'vareps', vareps, 'trunc_mode', trunc_mode, 'stats_gatherer', stats_gatherer, 'stats', stats );
relerr=tensor_error( Ui2, Ui, [], true );

k=tensor_rank(Ui);
if eps>0
    R=relerr/eps;
else
    R=1;
end

U2=apply_boundary_conditions_solution( Ui2, G, P_I, P_B );
