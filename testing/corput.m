function corput

clf
xlim([0,1]);
ylim([0,1]);
axis equal
x=[];
M=100;
for i=0:1000
    N=(M*i):(M*(i+1)-1);
    
    x=[x [gb(N,3);gb(N,7)]];
    plot(x(1,:),x(2,:),'.');
    drawnow;
end
1;



function g=gb( n, b )

g=0;
x=1/b;
while n>0
    d=mod(n,b);
    g=g+d*x;
    n=round((n-d)/b);
    x=x/b;
end
