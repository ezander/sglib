function mh


N=10000;
beta=1;
x=6;
X=[];
for i=1:N
    xn=x+beta*(rand-0.5);
    a1=exp(-xn^2)/exp(-x^2);
    a2=1;
    a=a1*a2;
    if a>=1 || rand<a
        x=xn;
    end
    if i<100; continue; end
    
    X=[X x];
end

hold off;
kernel_density(X,[],0.2); hold all;
empirical_density(X); hold all;

