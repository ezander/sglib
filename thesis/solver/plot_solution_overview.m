function plot_solution_overview(model, info)
close
multiplot_init(2,2)
multiplot
rho=info.rho;
errest=rho/(1-rho)*info.updnormvec/info.norm_U+info.epsvec;

% Achtung: fieser hack here
while length(info.errvec)<length(info.resvec)
    info.errvec(end+1)=info.errvec(end);
end

plot( info.errvec, 'x-' ); legend_add( 'rel. error' );
plot( errest, '*-' ); legend_add( 'error est.' );
plot( info.resvec/info.resvec(1), 'o-' ); legend_add( 'rel. residual' );
plot( info.updvec, 'd-' ); legend_add( 'update ratio' );
logaxis( gca, 'y' )
save_figure( gca, {'update_ratio_error_and_residual_%s', model} );

multiplot;
plot( info.rank_res_before, 'x-' ); legend_add( 'rank residuum' );
plot( info.rank_sol_after, 'x-' ); legend_add( 'rank solution' );
save_figure( gca, {'ranks_res_and_sol_%s', model} );
