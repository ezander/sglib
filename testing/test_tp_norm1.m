function test_tp_norm1

N=10;
M=12;
K=7;

U=rand(M,K);
V=rand(N,K);
A=U*V';

format compact
format short g

clc
norm(A,1)
norm_proj_est( U, V, 1, inf )

norm(A,2)
norm_proj_est( U, V, 2, 2 )

norm(A,inf)
norm_proj_est( U, V, inf, 1 )

norm(A,'fro')
norm_inj_est( U, V )


function est=norm_inj_est( U, V )
M=size(U,1);
N=size(V,1);
K=size(V,2);

est=0;
for i=1:10000
    a=rand(M,1);
    b=rand(N,1);
    r=rand(K,1);
    a=(U*r);
    b=(V*r);
    nest=abs(sum((a'*U).*(b'*V)))/sqrt((a'*a)*(b'*b));
    est=max(est,nest);
end

    
function est=norm_proj_est( U, V, t1, t2 )
M=size(U,1);
N=size(V,1);
K=size(V,2);

est=0;
for i=1:K
    est=est+norm(U(:,i),t1)*norm(V(:,i),t2);
end

