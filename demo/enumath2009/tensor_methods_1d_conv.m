clear;

build={
    './model_1d.m', './model_1d_ws.mat';
    './conv_pcg_1d.m', './conv_pcg_1d_ws.mat';
    };
autoloader;

% NS_build=build;
% NS_last={};
% 
% for NS_i=1:size(NS_build,1)
%     NS_script=NS_build{NS_i,1};
%     NS_target=NS_build{NS_i,2};
%     NS_mdep=depfun(NS_script,'-toponly','-quiet');
%     NS_dep={NS_script,NS_last{:},NS_mdep{:}};
%     if needs_update( NS_target, NS_dep )
%         underline(['Running ', NS_script]);
%         run( NS_script );
%         expr='^([^N]..|.[^S].|..[^_])'; % match anything except stuff starting with NS_
%         save( NS_target, '-regexp', expr );
%     else
%         underline( ['Loading ', NS_target]);
%         load( NS_target );
%     end
%     
%     NS_last={NS_target,NS_last{:}};
% end
% 
% if needs_update( './model_1d_ws.mat', './model_1d.m' )
%     underline('Running model_1d');
%     run( 'model_1d' );
%     save( 'model_1d_ws.mat' );
% else
%     underline('Loading model_1d');
%     load( 'model_1d_ws.mat' );
% end    
% 
% 
% if needs_update( './conv_pcg_1d_ws.mat', {'./model_1d_ws.mat', './conv_pcg_1d.m', '../../tensor_operator_solve_pcg.m'} )
%     underline('Running conv_pcg_1d');
%     run( 'conv_pcg_1d' );
%     save( './conv_pcg_1d_ws.mat' );
% else
%     underline('Loading conv_pcg_1d');
%     load( './conv_pcg_1d_ws.mat' );
% end    



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
plot( n, logscale(tol), '-x', n, logscale(relerr), '-x' );
xlabel('n', tex_opts{:}); 
ylabel('log_{10}(\epsilon), log_{10}(E)', text_opts{:});
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


