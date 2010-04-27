function show_kl_decay_by_dimen

mh=multiplot_init( 3, 3);
cov_funs={...
    {@gaussian_covariance, {1/sqrt(10),1}},...
    {@exponential_covariance, {1/sqrt(10),1}},...
    {@spherical_covariance, {1/sqrt(10),1}}};

for fun=1:length(cov_funs)
    for d=1:3
        N=ceil(500^(1/d));
        xd=repmat( linspace(0,1,N), d, 1);
        wd=repmat( ones(1,N), d, 1);
        x=tensor_mesh( num2cell(xd, 2 ), num2cell(wd, 2 ) );
        
        V_a=cov_funs{fun};
        C_a=covariance_matrix( x, V_a );
        
        [v, sigma]=kl_solve_evp( C_a, [], 200 );
        sigma_all=sigma;
        
        n=100;
        sigma=sigma_all(1:n);
        is=1:n;
        multiplot( mh, 1, fun);
        semilogy(is, sigma/sigma(1)); grid on;
        %subplot( 3, 3, d+3); plot(log(is), log(-log(sigma/sigma(1)))); axis equal; grid on
        
        multiplot( mh, 2, fun);
        plot(log(is), log(sigma/sigma(1))); grid on;
        
        multiplot( mh, 3, fun);
        semilogy(is, kl_remainder(sigma_all,n)); grid on;
    end
end
save_figure( mh(1,1), 'kl_decay_by_dimen_gauss_eigenvals' );
save_figure( mh(2,1), 'kl_decay_by_dimen_gauss_logeigen' );
save_figure( mh(3,1), 'kl_decay_by_dimen_gauss_remainder' );

save_figure( mh(1,2), 'kl_decay_by_dimen_exp_eigenvals' );
save_figure( mh(2,2), 'kl_decay_by_dimen_exp_logeigen' );
save_figure( mh(3,2), 'kl_decay_by_dimen_exp_remainder' );

save_figure( mh(1,3), 'kl_decay_by_dimen_spher_eigenvals' );
save_figure( mh(2,3), 'kl_decay_by_dimen_spher_logeigen' );
save_figure( mh(3,3), 'kl_decay_by_dimen_spher_remainder' );

