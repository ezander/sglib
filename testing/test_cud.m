function test_cud

clc
for b=0:2
    subplot(3,1,b+1);
    x=get_points( 1000, 5, b );
    plot( x(:,1), x(:,2), '.' )
    round(1e7*mean(x))
    round(1e3*var(x))
    round(1e3*cov(x))
    axis equal;
end

function x=get_points( n, d, b )
x=2*rand(n,d)-1;
x=x-repmat(mean(x),n,1);
if b>=1
    y=orth(x);
    y=y*diag(sqrt(1/3*n));
    x=y;
end
if b>=2
    z=linspace(-1,1,n);
    for i=1:d
        [u,j]=sort(x(:,i));
        x(:,i)=z(j);
    end
end




