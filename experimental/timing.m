function timing

T=[];
N=[];
t_lim=.5;
n=1; dx=2;
while 1
    n
    t=svd_timing(n);
    T=[T t];
    N=[N n];
    if t>t_lim; break; end
    %n=ceil(n*1.1);
    n=n+dx;
end
%semilogy(N,T)

s=floor(length(N)*2/3);
N=N(s:end);
T=T(s:end);
p=polyfit(log(N), log(T), 1 )
plot(log(N),log(T))
hold on
plot( log(N),p(2)+log(N)*p(1))
hold off

function t=svd_timing(n)
X=rand(n);
tic; [u,s,v]=svd(X); t=toc;
