function show_in_out_samples( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, n )
clf;
subplot(1,3,1); plot_pce_realizations_1d( x, k_alpha, I_k, 'realizations', n, 'show_stat', 3 );
subplot(1,3,2); plot_pce_realizations_1d( x, f_alpha, I_f, 'realizations', n, 'show_stat', 3 );
subplot(1,3,3); plot_pce_realizations_1d( x, u_alpha, I_u, 'realizations', n, 'show_stat', 3 );

%%
