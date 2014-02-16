function U=ctensor_truncate_variable( T, trunc, varargin )
if trunc.vareps 
    upratio=get_update_ratio();
    if abs(upratio-1)>trunc.vareps_threshold
        trunc.eps=trunc.eps*trunc.vareps_reduce;
        fprintf('Reducing eps to %g\n',  trunc.eps );
    end
end    
U=ctensor_truncate( T, 'eps', trunc.eps, 'k_max', trunc.k_max, varargin{:} );
if trunc.show_reduction
    r1=ctensor_rank(T);
    r2=ctensor_rank(U);
    fprintf( 'vari: %d->%d\n', r1, r2 );
end

