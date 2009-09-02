function demo_sparsity

clf;
subplot(1,2,1); sp_plots( 0, 0, 4, 2, 4, false ); title( 'degree ordering' );
subplot(1,2,2); sp_plots( 0, 0, 4, 2, 4, true ); title( 'lexicographical ordering' );
subtitle( 'Ordering comparison' );
userwait;

clf;
subplot(2,2,1); sp_plots( 0, 0, 4, 2, 4, false );
subplot(2,2,2); sp_plots( 1, 1, 4, 2, 4, false );
subplot(2,2,3); sp_plots( 2, 2, 4, 2, 4, false );
subtitle( 'RHS expansion comparison' );
userwait;

clf;
subplot(2,2,1); sp_plots( 0, 0, 4, 1, 4, false );
subplot(2,2,2); sp_plots( 0, 0, 4, 2, 4, false );
subplot(2,2,3); sp_plots( 0, 0, 4, 4, 4, false );
subplot(2,2,4); sp_plots( 0, 0, 4, 5, 4, false );
subtitle( 'Operator expansion comparison' );
userwait;



function sp_plots( m_f, p_f, m_k, p_k, p_u, lex_ordering )

I_k=multiindex(m_k,p_k,[],'lex_ordering', lex_ordering);

I_f=multiindex(m_f,p_f,[],'lex_ordering', lex_ordering);

[I_f,I_k,I_u]=multiindex_combine({I_f,I_k},p_u,'lex_ordering', lex_ordering);

p_u=size(I_u,2);
hermite_triple_fast( p_u );

C=hermite_triple_fast( I_u, I_u, I_k );
S=sum(C,3);
spy2(S, 'display', 'density');
drawnow;
