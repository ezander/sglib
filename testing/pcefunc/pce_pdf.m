function y=pce_pdf( x, pcc )%, pci )

if nargin==0
    pce_pdf( [-10 -8 -4 3]', [3 5 7] )
    return
end

n=size(pcc,1)-1;
h=hermite( n, true );
p=pcc'*h;
dp=polyder(p);

y=x;
for i=1:length(x(:))
    q=p;
    q(end)=q(end)-x(i);
    r=roots( q );
    r=sort(r(imag(r)==0));
    
    sign_minf=sign(p(1))*(1-2*mod(n,2));
    if sign_minf<0
        r=[-inf; r];
    end
    
    sign_inf=sign(p(1));
    if sign_inf<0
        r=[r; inf];
    end
    
    y(i)=0;
    for k=1:2:length(r)
        y(i)=y(i)+(normal_pdf(r(k+1))/polyval(dp,r(k+1)))-(normal_pdf(r(k))/polyval(dp,r(k)));
        %
    end
end
