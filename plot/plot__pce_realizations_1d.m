function stoch_plot_1d( x, u_alpha, I_u, n )
[mu_u, var_u]=pce_moments( u_alpha, I_u);
std_u=sqrt(var_u);
plot(x,mu_u, 'b', ...
    x, mu_u*[1,1]+std_u*[-1,1], 'g', ...
    x, mu_u*[1,1]+2*std_u*[-1,1], 'y', ...
    x, mu_u*[1,1]+3*std_u*[-1,1], 'r' );
hold all;
for i=1:n
    plot(x,pce_field_realization(x,u_alpha,I_u),'-k');
end
hold off

%%
