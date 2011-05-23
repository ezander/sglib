clc
scale=@(x)(round(log2(x)));
dif=@(A,x,xs)(scale(norm(x-xs)/norm(x)/cond(A))+53);
dif=@(A,x,xs)(scale(norm(A*x-A*xs)));
dif=@(A,x,xs)(scale(norm(x-xs)));

for k=2:12
    A=hilb(k);
    x=ones(k,1);
    b=A*x;
    x1=A\b;
    [L,U]=lu(A);
    x2=U\(L\b);
    [Q,R]=qr(A);
    x3=R\(Q'*b);
    R=chol(A);
    x4=R\(R'\b);
    [U,S,V]=svd(A);
    IS=diag(1./diag(S));
    x5=V'\(IS*(U\b));
    %x5=V'\(S\(U\b));
    fprintf( '%2d: %3g, %4g %4g %4g %4g %4g\n', k, scale(cond(A)), dif(A,x,x1), dif(A,x,x2), dif(A,x,x3), dif(A,x,x4), dif(A,x,x5) );
end
