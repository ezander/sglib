underline( 'Tensor product PCG: ' );

%% general options
reltol=1e-3;

%% truncation options
options.eps=get_base_param( 'XXeps', 1e-4 );
options.k_max=80;
%options.eps=get_base_param( eps, 0 );
%options.trunc_mode=get_base_param( trunc_mode, 3 );
options.trunc_mode=2;
options.relcutoff=true;
options.vareps=get_base_param( 'vareps', false );
options.vareps_threshold=0.1;
options.vareps_reduce=0.1;
%options.G={P_I*G_N*P_I', G_X};
options.show_reduction=false;
options.show_reduction=true;

%% stats stuff
%options.stats_func=@pcg_gather_stats;
options.stats=struct();
if exist('Ui_true', 'var')
    options.stats.X_true=Ui_true;
end
%options.stats.trunc_options=trunc_options;
options.stats.G={P_I*G_N*P_I', G_X};


if exist('Ui_true', 'var')
    options.stats.X_true=Ui_true;
end

%% call pcg
opts=struct2options(options);

tic; fprintf( 'Solving (tpcg): ' );
[Ui,flag,info,stats]=tensor_operator_solve_pcg( Ki, Fi, 'Minv', Mi_inv, 'reltol', reltol, opts{:} );
toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

% U=apply_boundary_conditions_solution( Ui, G, P_I, P_B );
