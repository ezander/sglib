n=1000;

subplot(2,3,1)
x = rand(n, 2);
plot(x(:,1), x(:,2), '.')
title('rand');

subplot(2,3,2)
x = halton_sequence(n, 2);
plot(x(:,1), x(:,2), '.');
title('halton');
xlabel('x_1'); ylabel('x_2');

subplot(2,3,3)
x = halton_sequence(n, 11);
plot(x(:,10), x(:,11), '.')
title('halton');
xlabel('x_{10}'); ylabel('x_{11}');

subplot(2,3,4)
x = halton_sequence(n, 11, 'scramble', 'bw');
plot(x(:,10), x(:,11), '.')
title('halton (scramble=bw)');
xlabel('x_{10}'); ylabel('x_{11}');

subplot(2,3,5)
x = halton_sequence(n, 11, 'shuffle', true);
plot(x(:,10), x(:,11), '.')
title('halton (shuffle)');
xlabel('x_{10}'); ylabel('x_{11}');

subplot(2,3,6)
x = halton_sequence(n, 10);
plot3(x(:,1), x(:,2), x(:,3), '.')
