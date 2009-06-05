function jaboci_simple

persistent s

if isempty(s)
    s = rand('seed')
end    
rand('seed',s)

%A=gallery('wathen',3,3);
clc
for n=3:20
    A = gallery('tridiag',n,-1,2,-1);
    F=rand(size(A,1),1);
    X1=A\F;
    %X2=jacobi(A,F);
    X2=jacobi_tens(A,F);
    D=diag(diag(A));
    fprintf( '%d:  %g   %g   %g\n', n, norm(X2-X1)/norm(X1), diagdom(A), max(abs(eig(D\(A-D))))^200 );
end




function X=jacobi_tens( A, F, M )

if nargin<3 || isempty(M)
    M=diag(diag(A));
end

Xc=zeros(size(F));
Rc=F;
for i=1:200
    %DX=M\Rc;
    DX=tensor_solve_elementary( M, Rc );
    % X=X+DX
    Xc=tensor_add( Xc, DX );
    % R=F-A*X;
    Rc=tensor_add( F, tensor_operator_apply( A, Xc ), -1 );
end
X=Xc;













function X=jacobi( A, F, M )

if nargin<3 || isempty(M)
    M=diag(diag(A));
end

Xc=zeros(size(F));
Rc=F;
for i=1:200
    DX=M\Rc;
    Xc=Xc+DX;
    %Rc=Rc-A*DX;
    Rc=F-A*Xc;
end
X=Xc;


function d=diagdom( A )
d=diag(A);
A=A-diag(d);
d=full(d-sum(abs(A),2));
d=all(d(:)>=0);
