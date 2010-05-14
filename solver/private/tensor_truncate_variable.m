function U=tensor_truncate_variable( T, trunc )
if trunc.vareps 
    upratio=get_update_ratio();
    if abs(upratio-1)>trunc.vareps_threshold
        trunc.eps=trunc.eps*trunc.vareps_reduce;
        fprintf('Reducing eps to %g\n',  trunc.eps );
    end
end    
U=tensor_truncate( T, 'eps', trunc.eps, 'k_max', trunc.k_max );
if trunc.show_reduction
    r1=tensor_rank(T);
    r2=tensor_rank(U);
    fprintf( 'vari: %d->%d\n', r1, r2 );
end

