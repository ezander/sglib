if verbosity>0; 
    fprintf( 'Solving (%s,%s): ', solver_name, vector_type ); 
end

timers( 'resetall' );
solver_start_tic=tic;
profile( 'on' );
