function show_solution_comparison(model, infos)
saveit=strcmp(infos{end}.descr,'dynamic');

close
multiplot_init(2,3)

show_stuff( 'errvec', 'rel. error', 'y', infos );
if saveit; save_figure( gca, {'compare_rel_err_by_trunc_mode_%', model} ); end
show_stuff( 'resvec', 'rel. residual', 'y', infos );
show_stuff( 'updvec', 'update ratio', '', infos );
show_stuff( 'epsvec', 'epsilon', 'y', infos );
show_stuff( 'rank_res_before', 'rank residual', '', infos );
if saveit; save_figure( gca, {'compare_res_rank_by_trunc_mode_%s', model} ); end
show_stuff( 'rank_sol_after', 'rank solution', '', infos );

function show_stuff( field, title_str, logax, infos )
marker={'-x','-*','-o','-+', '-s', '-^', '-d', '-v', '-p'};
multiplot; 
title( title_str );  
num=length(infos);
for i=1:num; 
    plot( infos{i}.(field), marker{i} ); 
    legend_add( infos{i}.descr ); 
end;  
logaxis( gca, logax ); 
legend( legend, 'location', 'best' );
