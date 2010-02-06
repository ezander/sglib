function show_hermite_polynomials

x=linspace(-3.5,3.5);
y=hermite_val( unitvector(5)', x );
y=y.*exp(-x.^2/2)/sqrt(2*pi);
plot(x,y)


x=linspace(-3.5,3.5);
y=hermite_val_multi( unitvector([1,3,5])', x );
y=y.*exp(-x.^2/2)/sqrt(2*pi);
plot(x,y)

p=hermite(4, true);
x=linspace(-3.5,3.5);
y=polyval(p,x);
%y=y.*exp(-x.^2/2)/sqrt(2*pi);

plot(x,y)
