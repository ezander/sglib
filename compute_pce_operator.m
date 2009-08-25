function K=compute_pce_operator( k_iota, I_k, I_u, stiffness_func, form, variant )

if nargin<6
    variant=1;
end
if nargin<5
    form='iota';
end

switch form
    case { 'alpha_beta' }
        switch variant
            case 1
                K=assemble_alpha_beta( k_iota, I_k, I_u, stiffness_func );
            case 2
                K=assemble_alpha_beta2( k_iota, I_k, I_u, stiffness_func );
        end
    case { 'alpha_beta_mat' }
        switch variant
            case 1
                K=cell2mat( assemble_alpha_beta( k_iota, I_k, I_u, stiffness_func ) );
            case 2
                K=cell2mat( assemble_alpha_beta2( k_iota, I_k, I_u, stiffness_func ) );
        end
    case { 'iota' }
        K=assemble_iota( k_iota, I_k, I_u, stiffness_func );
    otherwise
end


function K=assemble_iota( k_iota, I_k, I_u, stiffness_func )
m_iota_k=size(I_k,1);
K_iota=cell(m_iota_k,1);
for iota=1:m_iota_k
    K_iota{iota}=funcall( stiffness_func, k_iota(:,iota) );
end
K={K_iota;I_k;I_u};


function K=assemble_alpha_beta( k_iota, I_k, I_u, stiffness_func )
m_iota_k=size(I_k,1);
K_iota=cell(m_iota_k,1);
for iota=1:m_iota_k
    K_iota{iota}=funcall( stiffness_func, k_iota(:,iota) );
end

m_alpha_u=size(I_u,1);
K_ab=cell(m_alpha_u,m_alpha_u);
n=size(k_iota,1);
for alpha=1:m_alpha_u
    for beta=1:alpha
        K_ab{alpha,beta}=sparse(n,n);
        for iota=1:m_iota_k
            K_ab{alpha,beta}=K_ab{alpha,beta}+...
                hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(iota,:))*K_iota{iota};
        end
        K_ab{beta,alpha}=K_ab{alpha,beta};
    end
end
K=K_ab;


function K=assemble_alpha_beta2( k_iota, I_k, I_u, stiffness_func )
m_alpha_u=size(I_u,1);
K_ab=cell(m_alpha_u,m_alpha_u);
n=size(k_iota,1);
m_iota_k=size(I_k,1);
for alpha=1:m_alpha_u
    for beta=1:alpha
        k_ab=zeros(n,1);
        for iota=1:m_iota_k
            k_ab=k_ab+hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(iota,:))*k_iota(:,iota);
        end
        K_ab{alpha,beta}=funcall( stiffness_func, k_ab );
        K_ab{beta,alpha}=K_ab{alpha,beta};
    end
end
K=K_ab;
