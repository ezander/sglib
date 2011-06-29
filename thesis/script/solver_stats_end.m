profile( 'off' )

info.solve_time=toc(solver_start_tic);
info.prof=profile('info');
info.timers=timers( 'getall' );
info.rank_K=size(Ki,1);
if exist( 'options', 'var' )
    info.solve_options=options;
end

if verbosity>0
    toc(solver_start_tic); 
    strvarexpand( 'Flag: $flag$, iter: $info.iter$, relres: $info.relres$' );
end
