n=60;
s=orthpol_info( 'legendre', n, [])

a=s.a3n./s.a1n; 
b=s.a2n./s.a1n; 
c=s.a4n./s.a1n;
alpha=b./a;
beta=c./a;

ps=orthpol( 'legendre', n, [] );

alpha(end)=[];
beta(end)=[];

p=ps(n+1,:);
r1=sort(roots(p));
r2=sort(eig(diag(alpha)+diag(sqrt(beta(2:end)),1)+diag(sqrt(beta(2:end)),-1)));
[r1 r2 r1-r2]
[polyval(p,r1) polyval(p,r2) abs(polyval(p,r1))>=abs(polyval(p,r2))]
