function x_gamma=pce_divide( a_alpha, I_a, b_beta, I_b, I_x )

if nargin<5
    I_x=I_a;
end

m_a=size(I_a,1);
m_x=size(I_x,1);
A=compute_pce_rhs( a_alpha, I_a );
K=zeros(m_a,m_x);

for j=1:m_a
    alpha=I_a(j,:);
    for k=1:m_x;
        gamma=I_x(k,:);
        K(j,k)=b_beta*squeeze(hermite_triple_fast(alpha,gamma,I_b));
    end
end
x_gamma=(K\A')';
