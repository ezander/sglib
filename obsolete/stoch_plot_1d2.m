function stoch_plot_1d( x, u_alpha, I_u, n )
[mu_u, var_u]=pce_moments( u_alpha, I_u);
std_u=sqrt(var_u);
for i=1:n
    plot(x,pce_field_realization(x,u_alpha,I_u),'-', 'Color', [.5,.5,.5]);
hold all;
end
plot( x,mu_u, 'k', 'LineWidth', 2  );
plot( x, mu_u*[1,1]+std_u*[-1,1], 'r'  );
plot( x, mu_u*[1,1]+2*std_u*[-1,1], 'Color', [1,.5,0]  );
plot( x, mu_u*[1,1]+3*std_u*[-1,1], 'y' );
hold off
