N=20;
A=randn(N);
B=randn(N);
X=randn(N);
DX=1e-4*randn(N);
X2=X+DX;

D=X*B*A'+X*A*B';
%D=X*B'*A+X*A'*B;
format long
if false
    trace( A'*X'*X*B )
    trace( A'*X2'*X2*B )
    trace( A'*X2'*X2*B )-trace( A'*X'*X*B )
    trace( D'*DX )
else
    trace( A*(X+DX) )-trace( A*X )
    Y=A';
    trace( Y'*DX )
end

