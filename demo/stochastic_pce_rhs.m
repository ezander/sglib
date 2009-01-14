function f_j_beta=stochastic_pce_rhs( f_j_alpha, I_f, I_u)
m_alpha_f=size(I_f,1);
m_beta_u=size(I_u,1);
n=size(f_j_alpha,1);
f_j_beta=zeros( n, m_beta_u );
for i=1:m_alpha_f
    %ind=sum(abs(I_u-repmat(I_f(i,:),m_beta_u,1)),2)==0;
    ind=multiindex_find(I_u, I_f(i,:));
    f_j_beta(:,ind)=multiindex_factorial(I_f(i,:))*f_j_alpha(:,i);
end

return
% this has to be moved out
% NOTE: This is really ugly imposition of Dirichlet BCs
f_j_beta(bnd,:)=0;
% for inhomogeneous boundary conditions
if nargin>4 && ~isempty(g_func)
    f_j_beta(bnd,1)=funcall( g_func, pos(bnd,:) );
end

