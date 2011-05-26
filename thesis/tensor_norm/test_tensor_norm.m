function test_tensor_norm

T=make_op1
Tmat=tensor_operator_to_matrix( T );
size(Tmat)

1
norm(Tmat,1)
tensor_normest_projective( T, 1, 1 )

2
norm(Tmat,2)
tensor_normest_projective( T, 2, 2 )
norm(Tmat(:),2)
tensor_hilbert_schmidt( T )
tensor_normest_injective1( T )

inf
norm(Tmat,inf)
tensor_normest_projective( T, inf, inf )


function est=tensor_normest_projective( T, t1, t2 )
K=size(T,1);

est=0;
for i=1:K
    est=est+norm(T{i,1},t1)*norm(T{i,2},t2);
end

function est=tensor_normest_injective1( T )
K=size(T,1);

est=0;
for i=1:K
    est2=0;
    A=T{i,1};
    B=T{i,2};
    for j=1:K
        est2=est2+trace(T{j,1}'*A)*trace(T{j,2}'*B);
    end
    est=max(est,abs(est2)/sqrt(trace(A'*A)*trace(B'*B)));
end

%frobenius_inner

function est=tensor_hilbert_schmidt( T )
K=size(T,1);

est2=0;
for i=1:K
    for j=1:K
        est2=est2+trace(T{i,1}'*T{j,1})*trace(T{i,2}'*T{j,2});
    end
end
est=sqrt(est2);


function T=make_op1
N=10;
M=12;
K=7;

T={};
for i=1:K
    A=rand(M);
    B=rand(N);
    T(end+1,:)={A,B};
end
