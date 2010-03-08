underline( 'Tensor product PCG: ' );

%% general options
reltol=1e-3;

%% truncation options
%options.eps=get_param( eps, 1e-4 );
options.eps=get_param( eps, 0 );
%options.trunc_mode=get_param( trunc_mode, 3 );
options.trunc_mode=2;
options.relcutoff=true;
options.vareps=get_param( 'vareps', false );
options.vareps_threshold=0.1;
options.vareps_reduce=0.1;
%options.G={P_I*G_N*P_I', G_X};


%% stats stuff
%options.stats_func=@pcg_gather_stats;
options.stats=struct();
if exist('Ui_true', 'var')
    options.stats.X_true=Ui_true;
end
%options.stats.trunc_options=trunc_options;
options.stats.G={P_I*G_N*P_I', G_X};


%Fi2=tensor_to_pce(Fi);
Fi2=Fi;
%G2=tensor_to_pce(G);
G2=G;
if exist('Ui_true', 'var')
    options.stats.X_true=tensor_to_pce( Ui_true );
    %Ui_true2=tensor_to_pce(Ui_true);
    Ui_true2=Ui_true;
end

%% call pcg
opts=struct2options(options);

tic; fprintf( 'Solving (tpcg): ' );
[Ui,flag,info,stats]=tensor_operator_solve_pcg( Ki, Fi2, 'Minv', Mi_inv, 'reltol', reltol, opts{:} );
toc; fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );

% [Ui,flag,info,stats]=tensor_operator_solve_pcg( Ki, Fi2, 'reltol', reltol, opts{:} );
% fprintf( 'Flag: %d, iter: %d, relres: %g\n', flag, info.iter, info.relres );


relerr=gvector_error( Ui, Ui_true2, [], true );
if is_tensor(Ui)
    k=tensor_rank(Ui);
end

if eps>0
    R=relerr/eps;
else
    R=1;
end

U=apply_boundary_conditions_solution( Ui, G2, P_I, P_B );
