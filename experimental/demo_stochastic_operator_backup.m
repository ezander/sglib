clf; clear

addpath dummy/
%% Introductory images (2d)

rf_filename='ranfield_so.mat';
reinit=true;
if ~reinit && exist( rf_filename, 'file' ) 
    load( rf_filename )
else
    % definition of the grid
    n=21;
    x=linspace(0,1,n)';
    x=x+0*0.4*(x(2)-x(1))*(rand(size(x))-0.5);
    els=[1:n-1; 2:n]';
    M=mass_matrix( els, x );

    % expansion of the parameter hand side field (k)
    p_k=4;
    m_gam_k=4;
    m_k=5;

    p_k=2;
    m_gam_k=2;
    m_k=nchoosek(p_k+m_gam_k,m_gam_k);
    lc_k=0.3;
    h_k={@beta_stdnor,{4,2}};
    cov_k={@gaussian_covariance,{lc_k,1}};
    options_expand_k.transform.correct_var=1;
    [k_iota, I_k]=expand_field_pce_sg( h_k, cov_k, [], x, M, p_k, m_gam_k, options_expand_k );
    %TODO: error if m_k>m_iota_k
    [mu_k,k_i_iota,v_k_i]=pce_to_kl( k_iota, I_k, M, m_k );
    save( rf_filename, '-V6' );
end


if 0
    % Transform into different representations
    k_iota2=zeros(size(k_iota));
    k_iota2(1,:)=mu_k;
    k_iota2=k_iota2+k_i_iota*v_k_i;


    gam=randn(10000,m_gam_k);
    i=11;
    kernel_density( hermite_val_multi( k_iota(:,i), I_k, gam ), [], 0.02 );
    hold on;
    kernel_density( hermite_val_multi( k_iota2(:,i), I_k, gam ), [], 0.02, 'r' );
    hold off;
    round(log(abs((k_iota(2:end,i)-k_iota2(2:end,i)))./abs(k_iota(2:end,i))))'

    return
end

m_gam_u=m_gam_k;
p_u=p_k;
I_u=multiindex( m_gam_u, p_u );
m_alpha_u=size(I_u,1);


u_alpha=k_iota;


% Assemble the stochastic operator via the PC expansion of k
m_iota_k=size(I_k,1);
K_iota=cell(m_iota_k,1);
for iota=1:m_iota_k
    K_iota{iota}=stiffness_matrix( els, x, k_iota(:,iota) );
end

% Assemble in alpha-beta wise fashion from k_iota
K_ab=cell(m_alpha_u,m_alpha_u);
for alpha=1:m_alpha_u
    for beta=1:alpha
        if 0
            k_ab=zeros(n,1);
            for iota=1:m_iota_k
                k_ab=k_ab+hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(iota,:))*k_iota(:,iota);
            end
            K_ab{alpha,beta}=stiffness_matrix( els, x, k_ab );
        else
            K_ab{alpha,beta}=sparse(n,n);
            for iota=1:m_iota_k
                K_ab{alpha,beta}=K_ab{alpha,beta}+...
                    hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(iota,:))*K_iota{iota};
            end
        end
        K_ab{beta,alpha}=K_ab{alpha,beta};
    end
end

f_beta_1=zeros(size(u_alpha));
for alpha=1:m_alpha_u
    for beta=1:m_alpha_u
        f_beta_1(:,beta)=f_beta_1(:,beta)+K_ab{alpha,beta}*u_alpha(:,alpha);
    end
end

f_beta_3=zeros(size(u_alpha));
for iota=1:m_iota_k
    for alpha=1:m_alpha_u
        for beta=1:m_alpha_u
            f_beta_3(:,beta)=f_beta_3(:,beta)+...
                hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(iota,:))*...
                K_iota{iota}*u_alpha(:,alpha);
        end
    end
end


K_ab_mat=cell2mat(K_ab);
f_beta_2=reshape( K_ab_mat*reshape( u_alpha, [], 1 ), n, [] );

norm(f_beta_1-f_beta_2)
norm(f_beta_1-f_beta_3)

% Assemble the stochastic operator via the KL expansion of k
K_mu=stiffness_matrix( els, x, mu_k );
K_i=cell(m_k,1);
Delta_i=cell(m_k,1);
for i=1:m_k
    K_i{i}=stiffness_matrix( els, x, v_k_i(:,i) );
    Delta_i{i}=stochastic_pce_matrix( k_i_iota(i,:), I_k, I_u );
end
Delta_0=stochastic_pce_matrix( [1,zeros(1,m_iota_k-1)], I_k, I_u );
K_kl={K_mu,K_i,Delta_i};



f_beta_5=zeros(size(k_iota));
f_beta_5=f_beta_5+...
    K_mu*u_alpha*Delta_0;
for i=1:m_k
    f_beta_5=f_beta_5+...
        K_i{i}*u_alpha*Delta_i{i};
end
norm(f_beta_1-f_beta_5)


f_beta_4=zeros(size(k_iota));
for alpha=1:m_alpha_u
    for beta=1:m_alpha_u
        f_beta_4(:,beta)=f_beta_4(:,beta)+...
            hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(1,:))*...
            K_mu*u_alpha(:,alpha);
        for i=1:m_k
            for iota=1:m_iota_k
                f_beta_4(:,beta)=f_beta_4(:,beta)+...
                    k_i_iota(i,iota)*...
                    hermite_triple_product(I_u(alpha,:),I_u(beta,:),I_k(iota,:))*...
                    K_i{i}*u_alpha(:,alpha);
            end
        end
    end
end
norm(f_beta_1-f_beta_4)
norm(f_beta_5-f_beta_4)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return




f_ab=zeros(size(u));
for i=1:m_iota_k
    for j=1:m_iota_k
        f_ab(i,:)=(f_ab(i,:)'+K_ab{i,j}*u(j,:)')';
    end
end

return
for i=1:21
    gam=randn(10000,m_gam_k);
    kernel_density( hermite_val_multi( f_pce(:,i), I_k, gam ), [], 0.02 );
    hold on;
    kernel_density( hermite_val_multi( f_kl(:,i), I_k, gam ), [], 0.02, 'r' );
    kernel_density( hermite_val_multi( f_ab(:,i), I_k, gam ), [], 0.02, 'g' );
    hold off;
    waitforbuttonpress;
end
