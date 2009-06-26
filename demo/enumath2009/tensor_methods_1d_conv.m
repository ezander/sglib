clear;

build={
    './model_1d.m', './model_1d_ws.mat';
    './conv_pcg_1d.m', './conv_pcg_1d_ws.mat';
    };
autoloader;
clf;
undock;

%%
basename='pcg_1d_E%g';
params={round(abs(log10(reltol)))};
basename=sprintf(basename, params{:});


%% KL eigenfunctions
plot(pos,u_i_k); 
title('KL eigenfunctions of $u$', latex_opts{:});
title('KL eigenfunctions of $u$', tex_opts{:});
title('KL eigenfunctions of $u$', 'Interpreter', 'latex');
save_eps( basename, 'kl_eigenfuncs' );
print( 'rf_u_kl_eig.eps', '-depsc' );

%% Solution and realizations
plot_kl_pce_realizations_1d( pos, mu_u_i, u_i_k, u_k_alpha, I_u, 'realizations', 50 );
title('mean/var/samples of $u$', text_opts{:});
print( 'rf_u_kl_real.eps', '-depsc' );



%% Error and truncation
clf;
n=1:length(res); 
tol=cell2mat({res(n).tol});
relerr=cell2mat({res(n).relerr});
plot( logscale(tol,'cutoff',1e-15), logscale(relerr,'cutoff',1e-15), '-x' );
xlabel('log_{10}(\epsilon)', tex_opts{:}); 
ylabel('log_{10}(E)', text_opts{:});
print( 'pcg_conv1_n_eps.eps', '-depsc' );
userwait;

%% Numerical rank 
tol=cell2mat({res(n).tol});
k=cell2mat({res(n).k});
plot( logscale(tol), k, 'x-' ); 
title( 'Numerical rank' );
xlabel( 'log_{10}(\epsilon)', text_opts{:} );
ylabel( 'k', text_opts{:} );
print( 'pcg_conv1_numrank_over_eps.eps', '-depsc' );
userwait;

%% Number of iterations
tol=cell2mat({res(n).tol});
iter=cell2mat({res(n).iter});
plot( logscale(tol,'base',10), iter, 'x-' ); 
ylim([0,max(iter)]);
title( 'Iterations' );
xlabel( 'log_{10}(\epsilon)' );
ylabel( 'n' );

%% Update ratio 2D
val={}; for i=n; val={val{:}, res(i).info.update_ratio}; end
tol={res.tol};
iteration_plot( val, tol,  'Update ratio', '\tau', [], 0.002 );
ylim([-0.1,1.1]);


%% Update ratio 3D
delta=0.2;
val={}; for i=n; val={val{:}, max(min(res(i).info.update_ratio,1+delta),-delta)}; end
tol={res.tol};
iteration_plot3( val, tol,  'Update ratio', '\tau' );
%zlim([-0.1,1.1]);

%% Update ratio 1
i=1;
val={res(i).info.update_ratio};
tol={res(i).tol};
iteration_plot( val, tol,  'Update ratio', '\tau' );
ylim([-0.1,1.1]);

%% Update ratio 3
i=3;
val={res(i).info.update_ratio};
tol={res(i).tol};
iteration_plot( val, tol,  'Update ratio', '\tau' );
ylim([-0.1,1.1]);

%% Update ratio 5
i=5;
val={res(i).info.update_ratio};
tol={res(i).tol};
iteration_plot( val, tol,  'Update ratio', '\tau' );
ylim([-0.1,1.1]);

%% Update ratio 5
i=6;
val={res(i).info.update_ratio};
tol={res(i).tol};
iteration_plot( val, tol,  'Update ratio', '\tau' );
ylim([-0.1,1.1]);

%% Relative residual
val={}; for i=n; val={val{:}, logscale(res(i).info.res_relnorm)}; end
tol={res.tol};
iteration_plot( val, tol,  'Relative residual norm', '||r_\epsilon||/||r_0||', -.3 );

%% Relative error
val={}; for i=n; val={val{:}, logscale(res(i).info.sol_relerr)}; end
tol={res.tol};
iteration_plot( val, tol,  'Relative error norm', '||u_\epsilon-u||/||u||', -.3 );



%% Obsolete stuff
do_obsolete=false;
if do_obsolete
    %%
    val={}; for i=n; val={val{:}, logscale(res(i).info.res_norm)}; end
    tol={res.tol};
    iteration_plot( val, tol,  'Residual norm', '||r_\epsilon||' );
end
