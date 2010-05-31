clear

N=get_param( 'N', 50 );
[pos,els,bnd_nodes]=create_mesh_1d( 0, 1, N );
G_N=mass_matrix( pos, els );
stiffness_func={@stiffness_matrix, {pos, els}, {1,2}};


stdnor_k={@gendist_stdnor, {'beta', {2,4}, 0.001, 1.0 }};
cov_k={@exponential_covariance,{0.05,1}};
m_k=5; p_k=3; l_k=1;


% expand the field
[k_i_k,k_k_alpha,I_k,l_k]=expand_field_kl_pce( stdnor_k, cov_k, pos, G_N, p_k, m_k, l_k );

verbose=get_param( 'verbose', true );

tic
K=kl_pce_compute_operator(k_i_k, k_k_alpha, I_k, I_k, stiffness_func, 'tensor');
toc

S=zeros(size(K{2,2}));
ms=max(sum(I_k,2));
for i=1:size(S,1)
    for j=1:size(S,2)
        d=abs(I_k(i,:)-I_k(j,:));
        % if ismember(d, I_k, 'rows')
        if sum(d)<=ms
            S(i,j)=1;
        end
    end
end

subplot(2,1,1)
spy(K{2,2})

subplot(2,1,2)
spy(S)

