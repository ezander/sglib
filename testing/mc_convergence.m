function testit

M=1000;
c='3';
switch c
    case '1'
        func=@test1;
        p=-0.5;
    case '2'
        func=@test2;
        p=-0.5;
    case '2b'
        func=@test2b;
        p=-0.5;
    case '3'
        func=@test3;
        p=-0.5;
end

N=[];
D=[];
for i=3:12
    n=2^i;
    N=[N n];
    D=[D func(n,M)];
end
subplot(2,1,1)
plot(N,D.^(1/p),'x-');
subplot(2,1,2)
plot(N.^p,D,'x-');
clc
mean(D./(N.^p))



function del=test1( N, M )
X=randn( N, M );
mu=mean( X, 1 );
del=std(mu);

function del=test2( N, M )
X=randn( N, M );
v=var( X, 1 );
del=std(v-1);

function del=test2b( N, M )
X=randn( N, M );
v=var( X, 1 );
del=std(v-1);

function del=test3( N, M )
X=randn( N, M );
kurt=sum( X.^3, 1 )/N;
del=std(kurt);
