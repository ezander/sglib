function U=tensor_truncate_fixed( T, trunc )

U=tensor_truncate( T, 'eps', trunc.eps, 'k_max', trunc.k_max );
%gvector_error( T, U, 'relerr', true )

if get_option( trunc, 'show_reduction', false )
    r1=tensor_rank(T);
    r2=tensor_rank(U);
    fprintf( 'fixd: %d->%d\n', r1, r2 );
    if r1>300
        keyboard;
    end
end

