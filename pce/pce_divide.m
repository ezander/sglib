function x_gamma=pce_divide( a_alpha, I_a, b_beta, I_b, I_x )

if nargin<5
    I_x=I_b;
end

m_b=size(I_b,1);
m_x=size(I_x,1);
B=multiindex_factorial(I_b).*b_beta';
K=zeros(m_b,m_x);

for j=1:size(I_b,1)
    beta=I_b(j,:);
    for k=1:size(I_x,1);
        gamma=I_x(k,:);
        K(j,k)=a_alpha*squeeze(hermite_triple_fast(beta,gamma,I_a));
    end
end
x_gamma=(K\B)';
