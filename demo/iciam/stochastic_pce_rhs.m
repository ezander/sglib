function f_beta=stochastic_pce_rhs( f_alpha, I_f, I_u )
m_alpha_f=size(I_f,1);
m_beta_u=size(I_u,1);
n=size(f_alpha,1);
f_beta=zeros( n, m_beta_u );
for i=1:m_alpha_f
    ind=sum(abs(I_u-repmat(I_f(i,:),m_beta_u,1)),2)==0;
    f_beta(:,ind)=multiindex_factorial(I_f(i,:))*f_alpha(:,i);
end
% NOTE: This is really ugly imposition of Dirichlet BCs
f_beta(1,:)=0;
f_beta(end,:)=0;
f_beta(1,1)=0.0;
f_beta(end,1)=0;

%%
