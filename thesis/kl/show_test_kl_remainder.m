l_c=0.1;
func={@spherical_covariance, {l_c,1}};
func={@exponential_covariance, {l_c,1}};
func={@gaussian_covariance, {l_c,1}};

%%
N=500;
[pos,els]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );
C=covariance_matrix( pos, func );
[v,sigma]=kl_solve_evp(C, G_N, 300 );

%%
N=200;
N=90;
[pos,els]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );
C=covariance_matrix( pos, func );
[v,sigma_400]=kl_solve_evp(C, G_N, 80 );



%%
multiplot_init(2,1);

[rem10,params,sigma_ex10]=kl_estimate_eps(sigma(1:10), 'full', true, 'skip', 0, 'Nout', 120);
[rem20,params,sigma_ex20]=kl_estimate_eps(sigma(1:20), 'full', true, 'Nout', 120);
[rem30,params,sigma_ex30]=kl_estimate_eps(sigma(1:30), 'full', true, 'Nout', 120);
[rem40,params,sigma_ex40]=kl_estimate_eps(sigma(1:40), 'full', true, 'Nout', 120);
h=multiplot;
hold off;
semilogy(sigma); hold all;
semilogy(sigma_400);
%semilogy(sigma_ex10);
semilogy(sigma_ex20);
    semilogy(sigma_ex30);
semilogy(sigma_ex40);
xlim([1,80]);
legend( 'sig', 'sig200', 'sigex20', 'sigex30', 'sigex40' );

NN=length(sigma);
[remf,params,sigma_ex]=kl_estimate_eps(sigma(1:NN), 'full', true, 'N', NN );
[remf2,params,sigma_ex]=kl_estimate_eps(sigma(1:80), 'full', true );
h=multiplot;
plot(remf(1:40));
plot(remf2(1:40));
plot(rem20(1:40)); 
plot(rem30(1:40)); 
plot(rem40(1:40)); 
legend( 'rem', 'rem200', 'rem20', 'rem30', 'rem40' );
