function f_j_beta=stochastic_pce_rhs( f_j_alpha, I_f, I_u)
m_alpha_f=size(I_f,1);
m_beta_u=size(I_u,1);
n=size(f_j_alpha,1);
f_j_beta=zeros( n, m_beta_u );
for i=1:m_alpha_f
    ind=multiindex_find(I_u, I_f(i,:));
    f_j_beta(:,ind)=multiindex_factorial(I_f(i,:))*f_j_alpha(:,i);
end

