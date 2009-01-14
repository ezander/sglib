function Delta=stochastic_pce_matrix( k_iota, I_k, I_u )

hermite_triple_fast(max([I_k(:); I_u(:)]));

m_alpha_u=size(I_u,1);
Delta=zeros( m_alpha_u, m_alpha_u );
for alpha=1:m_alpha_u
    for beta=1:m_alpha_u %alpha
        Delta(alpha,beta)=k_iota*hermite_triple_fast( I_u(alpha,:), I_u(beta,:), I_k );
        Delta(beta,alpha)=Delta(alpha,beta);
    end
end
