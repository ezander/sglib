function show_sparsity_pattern( K_ab, n )
clf;
subplot( 1,3,1);
spy( K_ab(1:n,1:n) );
subplot( 1,3,2);
spy( K_ab(1:n:end,1:n:end) );
subplot( 1,3,3);
spy( K_ab );

%%
