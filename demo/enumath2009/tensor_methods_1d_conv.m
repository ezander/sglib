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
save_eps( basename, 'kl_eigenfuncs' );
title('KL eigenfunctions of u');
userwait;

%% Solution and realizations
plot_kl_pce_realizations_1d( pos, u_i_k, u_k_alpha, I_u, 'realizations', 50 );
save_eps( basename, 'solution' );
title('Mean, variance and samples of u');
userwait;

%% Error and truncation
clf;
n=1:length(res); 
tol=cell2mat({res(n).tol});
relerr=cell2mat({res(n).relerr});
plot( logscale(tol,'cutoff',1e-15), logscale(relerr,'cutoff',1e-15), '-x' );
xlabel('log_{10}(\epsilon)'); 
ylabel('log_{10}(E)');
save_eps( basename, 'error_over_trunc' );
userwait;


%% Numerical rank 
tol=cell2mat({res(n).tol});
r=cell2mat({res(n).k});
plot( logscale(tol), r, 'x-' ); 
xlabel( 'log_{10}(\epsilon)');
ylabel( 'r' );
save_eps( basename, 'num_rank' );
title( 'Numerical rank' );
userwait;

%% Number of iterations
tol=cell2mat({res(n).tol});
iter=cell2mat({res(n).iter});
plot( logscale(tol,'base',10), iter, 'x-' ); 
ylim([0,max(iter)]);
xlabel( 'log_{10}(\epsilon)' );
ylabel( '#iterations' );
save_eps( basename, 'num_iter' );
title( 'Iterations' );
userwait;

%% Update ratio 2D
val={}; for i=n; val={val{:}, res(i).info.update_ratio}; end
tol={res.tol};
%iteration_plot( val, tol,  'Update ratio', '\tau', [], 0.002 );
iteration_plot( val, tol,  '', '\upsilon', [], 0.002 );
ylim([-0.1,1.1]);
save_eps( basename, 'update_ratio_2d' );
userwait;


%% Update ratio 3D
delta=0.2;
val={}; for i=n; val={val{:}, max(min(res(i).info.update_ratio,1+delta),-delta)}; end
tol={res.tol};
%iteration_plot3( val, tol,  'Update ratio', '\upsilon' );
iteration_plot3( val, tol,  '', '\upsilon' );
save_eps( basename, 'update_ratio_3d' );
userwait;

%% Update ratio 1
i=1;
val={res(i).info.update_ratio};
tol={res(i).tol};
%iteration_plot( val, tol,  'Update ratio', '\upsilon' );
iteration_plot( val, tol,  '', '\upsilon' );
ylim([-0.1,1.1]);
save_eps( basename, 'update_ratio_E1' );
userwait;

%% Update ratio 3
i=3;
val={res(i).info.update_ratio};
tol={res(i).tol};
iteration_plot( val, tol,  'Update ratio', '\tau' );
ylim([-0.1,1.1]);
save_eps( basename, 'update_ratio_E3' );
userwait;

%% Update ratio 5
i=5;
val={res(i).info.update_ratio};
tol={res(i).tol};
iteration_plot( val, tol,  'Update ratio', '\tau' );
ylim([-0.1,1.1]);
save_eps( basename, 'update_ratio_E5' );
userwait;

%% Update ratio 6
i=6;
val={res(i).info.update_ratio};
tol={res(i).tol};
iteration_plot( val, tol,  'Update ratio', '\tau' );
ylim([-0.1,1.1]);
save_eps( basename, 'update_ratio_E6' );
userwait;

%% Relative residual
val={}; for i=n; val={val{:}, logscale(res(i).info.res_relnorm)}; end
tol={res.tol};
iteration_plot( val, tol,  'Relative residual norm', '||r_\epsilon||/||r_0||', -.3 );
save_eps( basename, 'rel_residual' );
userwait;

%% Relative error
val={}; for i=n; val={val{:}, logscale(res(i).info.sol_relerr)}; end
tol={res.tol};
iteration_plot( val, tol,  'Relative error norm', '||u_\epsilon-u||/||u||', -.3 );
save_eps( basename, 'rel_error_per_iter' );
userwait;

%% Relative error to truncated solution over truncation
val={}; for i=n; val={val{:}, res(i).info.soleps_relerr(end)}; end
tol={res.tol};
plot( logscale(cell2mat(tol)), logscale(cell2mat(val)), 'x-', logscale(cell2mat(tol)), logscale(cell2mat(tol)), 'x-' );
xlabel('log_{10}(\epsilon)'); 
ylabel('log_{10}(E)');
ylim([-8,0]);
save_eps( basename, 'rel_error_by_tol' );
userwait;




%% Obsolete stuff
do_obsolete=false;
if do_obsolete
    %%
    val={}; for i=n; val={val{:}, logscale(res(i).info.res_norm)}; end
    tol={res.tol};
    iteration_plot( val, tol,  'Residual norm', '||r_\epsilon||' );
end
