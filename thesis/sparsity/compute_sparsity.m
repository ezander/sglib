function [S,I_k,I_u]=compute_sparsity( m_k, p_k, m_f, p_f, p_u, alphasort, kfirst, revalpha ) 

I_k=multiindex( m_k, p_k );
I_f=multiindex( m_f, p_f );

if kfirst
    [I_k,I_f,I_u]=multiindex_combine({I_k,I_f},p_u); %#ok<ASGLU>
else
    [I_f,I_k,I_u]=multiindex_combine({I_f,I_k},p_u); %#ok<ASGLU>
end

if alphasort
    I_u=sortrows(I_u);
end

S=kl_pce_sparsity( I_u, I_k, false );
