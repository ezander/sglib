function demo_gauss_hermite
% DEMO_GAUSS_HERMITE Show some properties of Gauss-Hermite quadrature.

% Calculate integral of monomials with Gaussian weighting function. The
% result for x^i should be 0 for odd i and (i-1)!! for even i where
% n!!=1x3x5x...xn.
format compact
format short e
expect=@(n)( mod(n-1,2)*prod(1:2:(n-1)) );

err=[];
pow=@(x,i)(x.^i);
for i=0:10
    f={pow,{i},{2}};
    p=ceil((i+1)/2);
    err=[err, gauss_hermite(f,p)-expect(i)];
end
disp('Error in Gauss-Hermite quadrature for polynomials up to degree 10');
disp('using minimal sufficient quadrature order ceil((i+1)/2)');
disp(abs(err));

err=[];
for i=0:10
    f={pow,{i},{2}};
    p=2;
    err=[err, gauss_hermite(f,p)-expect(i)];
end
disp('Error in Gauss-Hermite quadrature for polynomials up to degree 10');
disp('using quadrature order p=2 sufficient for max degree n=2*p-1=3');
disp(abs(err));



% Testing multidimension gauss hermite quadrature
% (Since the integrand simply factors the results should be the same as the
% products of the single integrations.)
clear a b
a=zeros(5,5);
b=a;
pow2=@(x,i,j)(x(1)^i*x(2)^j);
for i=0:4;
    for j=0:4;
        f={pow2,{i,j},{2,3}};
        a(i+1,j+1)=gauss_hermite_multi( f, 2, 4 );
        b(i+1,j+1)=expect(i)*expect(j);
    end;
end;
disp('Result of Gauss-Hermite 2d quadrature');
disp(a);
disp('Difference to exact solution');
disp(a-b);

% This should give e
disp('The next output should be approx. zero');
disp(gauss_hermite_multi( @(x)(exp(x(1)+x(2))), 2, 6)-exp(1));
