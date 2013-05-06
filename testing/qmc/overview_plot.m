function overview_plot
n=1000;

subplot(2,2,1)
x = halton_sequence(n, 2);
plot(x(:,1), x(:,2), '.')

subplot(2,2,2)
x = halton_sequence(n, 14);
plot(x(:,11), x(:,13), '.')

subplot(2,2,3)
x = hammersley_set(n, 2);
plot(x(:,1), x(:,2), '.')

subplot(2,2,4)
x = halton_sequence(n, 10);
%plot3(x(:,1), x(:,2), x(:,3), '.')
plot3(x(:,7), x(:,8), x(:,9), '.')


