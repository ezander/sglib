profile( 'off' )

info.solve_time=toc(solver_start_tic);
info.prof=profile('info');
info.timers=timers( 'getall' );

if verbosity>0
    toc(solver_start_tic); 
    fprintf( 'Flag: %d, iter: %d, relres: %g \n', flag, info.iter, info.relres );
end
