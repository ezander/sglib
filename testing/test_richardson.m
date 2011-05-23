%rand('seed', 29138 );
N=10;
A=rand(N)-0.5;
A=A+A';
b=rand(N,1);
A=A+3*eye(N);
rho=max(abs(eig(A)));

clc
rho
l1=min(eig(A))
l2=max(eig(A))


for z=0.4:0.02:2.2
    w2=2/(l1+l2);
    w=z/rho;
    z2=rho*w2;
    %min(eig(eye(N)-w*A))
    %max(eig(eye(N)-w*A))
    x=0*b;
    for i=1:40
        x=x+w*(b-A*x);
    end
    fprintf( 'z: %g  x:%g  r:%g\n', z-z2, norm(x)/norm(b\A), norm(b-A*x)/norm(b) );
    if abs(z-z2)<=0.02; disp(' '); end
end
