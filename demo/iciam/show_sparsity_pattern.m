function show_sparsity_pattern( K_ab, n )
clf;
N=size(K_ab,1);
m=N/n;

subplot( 1,3,1);
spy( K_ab );
title( sprintf( 'full: %dx%d', N, N ) );

subplot( 1,3,2);
spy( K_ab(1:n:end,1:n:end) );
title( sprintf( 'blocks: %dx%d', m, m ) );

subplot( 1,3,3);
spy( K_ab(1:n,1:n) );
title( sprintf( 'block: %dx%d', n, n ) )



%%
