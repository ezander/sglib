function demo_sparsity

init_demos
clf

%setuserwaitmode( 'mouse' );

subplot(2,2,1); sp_plots( 0, 0, 4, 2, 4, true );
subplot(2,2,2); sp_plots( 1, 1, 4, 2, 4, true );
subplot(2,2,3); sp_plots( 2, 2, 4, 2, 4, true );


%sp_plots( 3, 2, 2, 3, false );
sp_plots( 1, 1, 4, 4, -1, false );
sp_plots( 0, 0, 4, 2, 4, false );
sp_plots( 1, 1, 4, 2, 4, false );
sp_plots( 2, 2, 4, 2, 4, false );

sp_plots( 2, 3, 4, 4, -1, false );


sp_plots( 0, 0, 4, 1, 4, false );
sp_plots( 0, 0, 4, 2, 4, false );
sp_plots( 0, 0, 4, 4, 4, false );
sp_plots( 0, 0, 4, 5, 4, false );

sp_plots( 1, 1, 4, 1, 4, false );
sp_plots( 1, 1, 4, 2, 4, false );
sp_plots( 1, 1, 4, 4, 4, false );
sp_plots( 1, 1, 4, 5, 4, false );


function sp_plots( m_f, p_f, m_k, p_k, p_u, lex_ordering )

I_k=multiindex(m_k,p_k,[],'lex_ordering', lex_ordering);

I_f=multiindex(m_f,p_f,[],'lex_ordering', lex_ordering);

[I_f,I_k,I_u]=multiindex_combine({I_f,I_k},p_u);

p_u=size(I_u,2);
hermite_triple_fast( p_u );

C=hermite_triple_fast( I_u, I_u, I_k );
S=sum(C,3);
spy2(S);

if false
    for i=1:size(I_k,1)
        c=hermite_triple_fast( I_u, I_u, I_k(i,:) );
        if i==1; T=c; else T=T+c; end
    end
    if any(T(:)~=S(:)); keyboard; end
    spy(T);
end



