function plot_solution_comparison(model, infos)
saveit=strcmp(infos{end}.descr,'dynamic');

close
multiplot_init(2,3)

plot_vectors( 'errvec', 'rel. error', 'y', infos );
if saveit; save_figure( gca, {'compare_rel_err_by_trunc_mode_%', model} ); end
plot_vectors( 'resvec', 'rel. residual', 'y', infos );
plot_vectors( 'updvec', 'update ratio', '', infos );
plot_vectors( 'epsvec', 'epsilon', 'y', infos );
plot_vectors( 'rank_res_before', 'rank residual', '', infos );
if saveit; save_figure( gca, {'compare_res_rank_by_trunc_mode_%s', model} ); end
plot_vectors( 'rank_sol_after', 'rank solution', '', infos );

function plot_vectors( field, title_str, logax, infos )
marker={'-x','-*','-o','-+', '-s', '-^', '-d', '-v', '-p', ...
        '-.x','-.*','-.o','-.+', '-.s', '-.^', '-.d', '-.v', '-.p'};
multiplot; 
title( title_str );  
num=length(infos);
for i=1:num; 
    plot( infos{i}.(field), marker{i} ); 
    legend_add( infos{i}.descr ); 
end;  
logaxis( gca, logax ); 
legend( legend, 'location', 'best' );
