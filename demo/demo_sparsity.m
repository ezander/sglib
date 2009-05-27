function demo_sparsity

init_demos
clf

check_condition( [], 'vector', false, '?', mfilename );
setuserwaitmode( 'mouse' );

clf;
subplot(2,1,1); sp_plots( 0, 0, 4, 2, 4, true );
subplot(2,1,2); sp_plots( 0, 0, 4, 2, 4, false );
userwait;

clf;
subplot(2,2,1); sp_plots( 0, 0, 4, 2, 4, true );
subplot(2,2,2); sp_plots( 1, 1, 4, 2, 4, true );
subplot(2,2,3); sp_plots( 2, 2, 4, 2, 4, true );
userwait;

clf;
subplot(2,2,1); sp_plots( 0, 0, 4, 1, 4, false );
subplot(2,2,2); sp_plots( 0, 0, 4, 2, 4, false );
subplot(2,2,3); sp_plots( 0, 0, 4, 4, 4, false );
subplot(2,2,4); sp_plots( 0, 0, 4, 5, 4, false );
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
