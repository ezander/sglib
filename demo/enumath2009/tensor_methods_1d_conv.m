clear;

build={
    './model_1d.m', './model_1d_ws.mat';
    './conv_pcg_1d.m', './conv_pcg_1d_ws.mat';
    };
autoloader;


clf;
plot(pos,u_i_k); 
title('KL eigenfunctions of $u$', text_opts{:});
print( 'rf_u_kl_eig.eps', '-depsc' );
plot_kl_pce_realizations_1d( pos, mu_u_i, u_i_k, u_k_alpha, I_u, 'realizations', 50 );
title('mean/var/samples of $u$', text_opts{:});
print( 'rf_u_kl_real.eps', '-depsc' );
userwait;



clf;
n=2:8; 

tol=cell2mat({res(n).tol});
relerr=cell2mat({res(n).relerr});
plot( n, logscale(tol,'cutoff',1e-12), '-x', n, logscale(relerr,'cutoff',1e-12), '-x' );
xlabel('n', tex_opts{:}); 
ylabel('log_{10}(\epsilon), log_{10}(E)', text_opts{:});
legend({'log_{10}(\epsilon)','log_{10}(E)'},text_opts{:});
print( 'pcg_conv1_n_eps.eps', '-depsc' );
userwait;


tol=cell2mat({res(n).tol});
k=cell2mat({res(n).k});
plot( -logscale(tol,'base',exp(1)), k, 'x-' ); 
title( 'Numerical rank' );
xlabel( 'log_{10}(\epsilon)', text_opts{:} );
ylabel( 'k', text_opts{:} );
print( 'pcg_conv1_numrank_over_eps.eps', '-depsc' );
userwait;

tol=cell2mat({res(n).tol});
iter=cell2mat({res(n).iter});
plot( -logscale(tol,'base',exp(1)), iter, 'x-' ); 
ylim([0,max(iter)]);
title( 'Iterations' );
xlabel( 'log(\epsilon)' );
ylabel( 'n' );


clf
hold on;
for i=1:8
    plot( res(i).info.update_ratio, 'x-' );
    title( 'Update Ratios' );
    xlabel( 'i' );
    ylabel( '\tau' );
end
hold off;


clf
hold on;
cols=get(gca,'ColorOrder');
for i=1:8
    plot( 0.2*i+logscale(res(i).info.res_norm), 'x-', 'Color', cols(mod(i,size(cols,1))+1,:) );
    title( 'Res. norm' );
    xlabel( 'i' );
    ylabel( '\tau' );
end
hold off;

clf
hold on;
cols=get(gca,'ColorOrder');
for i=1:8
    plot( 0.2*i+logscale(res(i).info.res_relnorm), 'x-', 'Color', cols(mod(i,size(cols,1))+1,:) );
    title( 'Relative res. norm' );
    xlabel( 'i' );
    ylabel( '\tau' );
end
hold off;


clf
hold on;
cols=get(gca,'ColorOrder');
for i=1:8
    plot( 0.2*i+logscale(res(i).info.sol_relerr), 'x-', 'Color', cols(mod(i,size(cols,1))+1,:) );
    title( 'Relative error norm' );
    xlabel( 'i' );
    ylabel( '\tau' );
end
hold off;


