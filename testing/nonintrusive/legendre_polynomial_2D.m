function y = legendre_polynomial_2D( p, x )
 
y =    legendre_polynomial_1D(p(1),x(1,:))...
    .* legendre_polynomial_1D(p(2),x(2,:));

end

