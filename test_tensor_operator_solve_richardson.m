function test_tensor_operator_solve_richardson

[A,Am,M, Mm, F,Fvec]=setup( 5, 3, 3, 2 );

XvecEx=Am\Fvec;

opts={ 'eps', 1e-7, 'k_max', 2 };

%[X,flag,info]=tensor_operator_solve_richardson( A, F, 'M', M );
[X,flag,info]=tensor_operator_solve_pcg( A, F, 'M', M );
Xvec1=reshape( X{1}*X{2}', [], 1 );
[Xvec2,flag,info]=tensor_operator_solve_pcg( Am, Fvec, 'M', Mm );

Mm2=diag(diag(Am));
[Xvec3,flag,info]=tensor_operator_solve_pcg( Am, Fvec, 'M', Mm2 );

norm( XvecEx-Xvec1 )
norm( XvecEx-Xvec2 )
norm( XvecEx-Xvec3 )





function [A,Am,M, Mm, F,Fvec]=setup( n, m, kA, kf )
A{1,1} = gallery('tridiag',n,-1,2,-1);
A{1,2} = gallery('randcorr',m);
for i=1:kA
    A{i+1,1} = 0.1*gallery('tridiag',n,-1,3,-1);
    A{i+1,2}=gallery('randcorr',m);
end
Am=revkron(A);

M=A(1,:);
Mm=revkron(M);

F={rand(n,kf),  rand(m,kf) };
Fvec=reshape( F{1}*F{2}', [], 1 );
