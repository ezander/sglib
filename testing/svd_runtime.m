n=100:5:400;

t=[];
for i=n
    ts=tic;
    te=toc(ts);
    m=0;
    while te<1
       m=m+1;
       A=rand(i);
       [u,s,v]=svd(A);
       te=toc(ts);
    end
    fprintf( '%3d %d %g %g\n', i, m, te, te/m );
    t=[t te/m];
end
    
plot(n,t)

p=polyfit( log(n), log(t), 1 )
plot(log(n),log(t),'.',log(n),p(1)*log(n)+p(2))


p=polyfit( n, t, 3 )