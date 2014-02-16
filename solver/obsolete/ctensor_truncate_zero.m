function U=ctensor_truncate_zero( T, trunc, varargin )
k_max=min(ctensor_size(T));
if ctensor_rank(T)>k_max
    U=ctensor_truncate( T, 'eps', 0, 'k_max', k_max, varargin{:} );
else
    U=T;
end
if trunc.show_reduction
    r1=ctensor_rank(T);
    r2=ctensor_rank(U);
    fprintf( 'zero: %d->%d\n', r1, r2 );
end


