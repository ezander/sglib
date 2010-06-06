function show_sparsity_large

p_u=3;
m_k=10; p_k=p_u;
m_f=20; p_f=p_u;
alphasort=true;
kfirst=false;


tic
S=compute_sparsity( m_k, p_k, m_f, p_f, p_u, alphasort, kfirst, false );
toc
multiplot_init(2,2)

multiplot; 
spy2(S, 'display', 'none' );
line( [1,1,400,400,1], [1,400,400,1,1], 'Color', 'r' );
line( [1,1,1000,1000,1], [1,1000,1000,1,1], 'Color', 'r' );
line( [810,810,940,940,810], [810,940,940,810,810], 'Color', 'r' );
save_figure( gca, 'sparsity_large_1', 'png'  );

                        
multiplot; spy2(S, 'display', 'none' ); xlim([1,400]); ylim([1,400]);
save_figure( gca, 'sparsity_large_2', 'png' );

multiplot; spy2(S, 'display', 'none' ); xlim([1,1000]); ylim([1,1000]);
save_figure( gca, 'sparsity_large_3', 'png' );

multiplot; spy2(S, 'display', 'none' ); xlim([810,940]); ylim([810,940]);
save_figure( gca, 'sparsity_large_4', 'png' );
