function show_in_out_samples( x, k_alpha, f_alpha, u_alpha, I_k, I_f, I_u, n )
clf;
subplot(1,3,1); stoch_plot_1d( x, k_alpha, I_k, n )
subplot(1,3,2); stoch_plot_1d( x, f_alpha, I_f, n )
subplot(1,3,3); stoch_plot_1d( x, u_alpha, I_u, n )

%%
