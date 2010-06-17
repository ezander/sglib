function [A,P,F,X]=setup_test_system( N, M, K_A, K_f, rho_A, rho_F )

M_mask=create_mask( M, 3 );
N_mask=create_mask( N, 2 );
    
A{1,1} = matrix_gallery('tridiag',N,-1,2,-1);
A{1,2} = matrix_gallery('randcorr',M);
A{1,2} = sparse(diag(diag(A{1,2})));

for i=1:K_A
    %A{i+1,1}=rho*matrix_gallery('tridiag',n,-1,3,-1);
    A{i+1,1}=rho_A*matrix_gallery('randcorr',N);
    A{i+1,1} = N_mask.*A{i+1,1};

    A{i+1,2}=rho_A*matrix_gallery('randcorr',M);
    A{i+1,2} = M_mask.*A{i+1,2};
end
P=A(1,:);

S=diag( rho_F.^(0:K_f-1) );
X={ orth(rand(N,K_f))*S, orth(rand(M,K_f)) };

F=tensor_operator_apply(A,X);
F=tensor_truncate(F);

function mask=create_mask( M, d )
mask=sparse(M,M);
for i=1:M; 
    mask( i, max(i-d,1):min(i+d,M) )=1;  %#ok<SPRIX>
end
