function f=apply_stochastic_operator( K, u )

if isnumeric(K)
    % assume K is just a huge matrix (i.e. the fully assembled Kronecker
    % product matrix); then we just apply K to u by matrix vector mult
    if size(u,2)==1
        % u is simply a column vector
        f=K*u;
    else
        % if u has two dimensional (matrix form) => multiply with
        % corresponding column vector and reshape into the original form
        f=reshape( K*u(:), size(u) );
    end
elseif iscell(K)
    if size(K,1)==size(K,2) 
        % Assume that the operator is in the form K_alpha_beta
        f=zeros(size(u));
        m_alpha_u=size(u,2);
        for alpha=1:m_alpha_u
            for beta=1:m_alpha_u
                f(:,beta)=f(:,beta)+K{alpha,beta}*u(:,alpha);
            end
        end
    elseif size(K,2)==1 && size(K,1)==3
        % Extract info from K
        K_iota=K{1};
        I_k=K{2};
        I_u=K{3};
        
        m_iota_k=size(I_k,1);
        m_alpha_u=size(I_u,1);
        f=zeros(size(u));
        for iota=1:m_iota_k
            for alpha=1:m_alpha_u
                for beta=1:m_alpha_u
                    f(:,beta)=f(:,beta)+...
                        hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(iota,:))*...
                        K_iota{iota}*u(:,alpha);
                end
            end
        end
    elseif size(K,2)==1 && size(K,1)==4
        % Extract info from K
        K_mu=K{1};
        Delta_mu=K{2};
        K_i=K{3};
        Delta_i=K{4};
        m_k=length(K_i);
        
        f=K_mu*u*Delta_mu;
        for i=1:m_k
            f=f+K_i{i}*u*Delta_i{i};
        end
    elseif size(K,2)==1 && size(K,1)==5
        K_mu=K{1};
        K_i=K{2};
        k_i_iota=K{3};
        I_u=K{4};
        I_k=K{5};

        m_alpha_u=size(I_u,1);
        m_iota_k=size(I_k,1);
        m_k=size(k_i_iota,1);
        f=K_mu*u*diag(multiindex_factorial(I_u));
        for alpha=1:m_alpha_u
            for beta=1:m_alpha_u
                for i=1:m_k
                    f(:,beta)=f(:,beta)+...
                        K_i{i}*u(:,alpha)*...
                        (k_i_iota(i,:)*...
                        hermite_triple_fast(I_u(alpha,:),I_u(beta,:),I_k));
                end
            end
        end
    else
        error('Unknown opertor.');
    end
else
    error('Unknown opertor.');
end
