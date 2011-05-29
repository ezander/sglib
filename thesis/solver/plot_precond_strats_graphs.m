function plot_precond_strats_graphs

global info_tp


rr=info_tp{1}.rank_res_before(2:end-1);
rs=info_tp{1}.rank_sol_after(2:end);

mean((rr./rs).^2)



i=1;
info_tp{i}.descr

close;
hold off;
plot( info_tp{i}.rank_res_before, 'x-' ); 
legend_add( 'residual' );

hold all;
plot( info_tp{i}.rank_sol_after, 'x-'); 
legend_add( 'solution' );

xlabel( 'rank' );
ylabel( 'iter' );

%save_figure( gca, 'rank_residual_and_solution' );
