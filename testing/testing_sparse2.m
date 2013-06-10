d = 3;
l = 4;


[x, w]  = full_tensor_grid(d, l, @clenshaw_curtis_nested);
subplot(2,2,1)
plot3(x(1,:), x(2,:), x(3,:), '.')
axis square


[x, w]  = smolyak_grid(d, l, @clenshaw_curtis_nested);
subplot(2,2,2)
plot3(x(1,:), x(2,:), x(3,:), '.')
axis square

l = 2^l+1;
l = 9;

[x, w]  = full_tensor_grid(d, l, @gauss_legendre_rule);
subplot(2,2,3)
plot3(x(1,:), x(2,:), x(3,:), '.')
axis square


[x, w]  = smolyak_grid(d, l, @gauss_legendre_rule);
subplot(2,2,4)
plot3(x(1,:), x(2,:), x(3,:), '.')
axis square
