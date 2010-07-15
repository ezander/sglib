function U=tensor_truncate_zero( T, trunc, varargin )
k_max=min(tensor_size(T));
if tensor_rank(T)>k_max
    U=tensor_truncate( T, 'eps', 0, 'k_max', k_max, varargin{:} );
else
    U=T;
end
if trunc.show_reduction
    r1=tensor_rank(T);
    r2=tensor_rank(U);
    fprintf( 'zero: %d->%d\n', r1, r2 );
end


