if verbosity>0; 
    strvarexpand( 'Solving ($solver_name$,$vector_type$): ' ); 
    strvarexpand( 'Options: $options$' ); 
end

timers( 'resetall' );
solver_start_tic=tic;
profile( 'on' );
