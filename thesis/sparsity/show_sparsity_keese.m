function show_sparsity_keese

p_u=4;
m_k=5; 
alphasort=~true;

multiplot_init(2,2);
for p_k=[1,2,4,5]
    S=compute_sparsity( m_k, p_k, 0, 1, p_u, alphasort, false, false );
    
    multiplot;
    spy2(S,'display','none');
    save_figure( gca, {'sparsity_keese_%d', p_k}, 'type', 'raster' );
end
