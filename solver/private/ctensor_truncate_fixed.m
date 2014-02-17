function U=ctensor_truncate_fixed( T, trunc, varargin )

U=ctensor_truncate( T, 'eps', trunc.eps, 'k_max', trunc.k_max, varargin{:} );
%tensor_error( T, U, 'relerr', true )

if get_option( trunc, 'show_reduction', false )
    r1=ctensor_rank(T);
    r2=ctensor_rank(U);
    fprintf( 'fixd: %d->%d\n', r1, r2 );
    if r1>300
        keyboard;
    end
end

