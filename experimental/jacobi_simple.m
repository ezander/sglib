function jaboci_simple

persistent s

if isempty(s)
    s = rand('seed')
end    
rand('seed',s)

%A=gallery('wathen',3,3);
clc
for n=3:2:10
    [A,X1,X2]=solve_compare2( n, 5 );
    %D=diag(diag(A));
    %fprintf( '%d:  %g   %g   %g\n', n, norm(X2-X1)/norm(X1), diagdom(A), max(abs(eig(D\(A-D))))^200 );
    fprintf( '%d:  %g   %g \n', n, norm(X2-X1)/norm(X1), diagdom(A) );
end


%%
function [A,X1,X2]=solve_compare2( n, m ) 
A{1,1} = gallery('tridiag',n,-1,2,-1);
A{2,1} = 0.1*gallery('tridiag',n,-1,3,-1);
A{1,2}=gallery('randcorr',m);
A{2,2}=gallery('randcorr',m);

M=A(1,:);
F={rand(n,1),  rand(m,1) };

A2=revkron(A);
F2=revkron(F);
M2=revkron(M);

solver=@jacobi_tens;
solver=@pcg_tens;
if false
    %M2=eye(size(M2));
    X2=solver(A2,F2,M2);
else
    X2=solver(A,F,M);
    disp(size(X2{1}));
%    X2
    X2=X2{1}*X2{2}';
    X2=X2(:);
end

X1=A2\F2;
A=A2;

%% default
function set_default( strvar, strdefault )


%%
function [X,flag,relres,iter]=pcg_tens( A, F, tol, maxit, M )


null_vector=@tensor_null;
add=@tensor_add;
prec_solve=@tensor_operator_solve_elementary;
apply_operator=@tensor_operator_apply;
if isnumeric(F)
    truncate=@tensor_truncate;
    inner_prod=@(a,b)(a'*b);
    vec_norm=@norm;
else
    truncate=@tensor_truncate;
    inner_prod=@tensor_scalar_product;
    vec_norm=@tensor_norm;
end

Xc=null_vector(F);

Rc=add( F, apply_operator( A, Xc ), -1);
Zc=prec_solve( M, Rc );
Pc=Zc;
k=0;
opts={ 'eps', 1e-7, 'k_max', 2 };
while true
    alpha=inner_prod(Rc,Zc)/inner_prod(Pc,apply_operator(A,Pc));
    Xn=add(Xc,Pc,alpha);
    Rn=add(Rc,apply_operator(A,Pc),-alpha);
    if vec_norm(Rn)<0.0001; break; end
    Zn=prec_solve(M,Rn);
    beta=inner_prod(Rn,Zn)/inner_prod(Rc,Zc);
    Pn=add(Zn,Pc,beta);
    
    k=k+1;
    Xc=truncate( Xn, opts );
    Pc=truncate( Pn, opts );
    Rc=truncate( Rn, opts );
    Zc=truncate( Zn, opts );
    if mod(k,100)==0
        keyboard
    end
end
X=truncate( Xn, opts );

%%
function X=pcg( A, F, M )

Xc=0*F;

Rc=F-A*Xc;
Zc=M\Rc;
Pc=Zc;
k=0;
while true
    alpha=(Rc'*Zc)/(Pc'*A*Pc);
    Xn=Xc+alpha*Pc;
    Rn=Rc-alpha*A*Pc;
    if norm(Rn)<0.001; break; end
    Zn=M\Rn;
    beta=(Rn'*Zn)/(Rc'*Zc);
    Pn=Zn+beta*Pc;
    
    k=k+1;
    Xc=tensor_truncate(Xn);
    Pc=Pn;
    Rc=Rn;
    Zc=Zn;
end
X=Xn;




%%











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
