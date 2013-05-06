function wikipedia_plot
x = halton_sequence(10, 2, 1);
plot(x(:,1), x(:,2), 'ro')
hold all;
x = halton_sequence(90, 2, 11);
plot(x(:,1), x(:,2), 'bo')
hold all;
x = halton_sequence(156, 2, 101);
plot(x(:,1), x(:,2), 'go')
axis equal
hold off;



