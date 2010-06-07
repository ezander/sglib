function show_sparsity_by_ordering

p_u=5;
m_k=5; p_k=2;
m_f=0; p_f=p_u;

multiplot_init(2,2);

for alphasort=[true, false]
    S=compute_sparsity( m_k, p_k, m_f, p_f, p_u, alphasort, true, false );
    
    multiplot;
    spy2(S);
    save_figure( gca, {'sparsity_ordering_%d', alphasort} ) ;
end
