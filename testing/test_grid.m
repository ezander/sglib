format compact
format short g

clf
f = @clenshaw_curtis_legendre_rule;
x = smolyak_grid(2, 5, f);
size(x)
plot(x(1,:), x(2,:), 'k.');
axis square

f = @gauss_hermite_rule;
smolyak_grid(4,7,f);


% for d=1:5
%     fprintf('\n\n');
%     underline(sprintf('d=%d', d));
%     for s=1:7
%         fprintf('s=%d  -  %4d  %4d  -  %4d %4d\n', [s, s^d, size(full_tensor_grid(d, s, f),2),  multiindex_size(d,s-1) size(smolyak_grid(d, s, f),2)]);
%     end
% end
