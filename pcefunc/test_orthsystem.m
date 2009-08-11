function test_orthsystem

n=6;
C=mk_orthsystem(@normal_raw_moments,n);
for i=1:n+1
    format_poly( C(i,:)/C(i,n+2-i), 'twoline', true, 'tight', false );
    fprintf('\n');
end

conv(C(2,:),C(3,:))




function C=mk_orthsystem(raw_moments_func,n)
m=funcall(raw_moments_func, 2*n);
M=hankel(m);
M=M(1:n+1,1:n+1);
C=flipdim( gram_schmidt( eye(n+1), M )', 2 );

function m=normal_raw_moments(n)
N=(0:n)';
N2=floor(N/2);
m=factorial(N)./(2.^N2.*factorial(N2));
m(2:2:n+1)=0;

function m=normal_raw_moments(n)
N=(0:n)';
N2=floor(N/2);
m=factorial(N)./(2.^N2.*factorial(N2));
m(2:2:n+1)=0;
