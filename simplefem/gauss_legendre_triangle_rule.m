function [x,w]=gauss_legendre_triangle_rule(p)
% GAUSS_LEGENDRE_TRIANGLE_RULE Get Gauss points and weights for quadrature over canonical triangle.

[x0,w0]=gauss_legendre_rule(p);

n=length(x0);
x=zeros(n*n,2);
w=zeros(n*n,1);
k=1;
for i=1:n
    for j=1:n
        x(k,1)=0.5*(1+x0(i));
        x(k,2)=0.25*(1-x0(i))*(1+x0(j));
        w(k)=0.125*w0(i)*w0(j)*(1-x0(i));
        k=k+1;
    end
end

