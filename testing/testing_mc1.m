state = electrical_network_init();

V = {'pp', multiindex(2, 0)};
% gpcspace_create('uniform', 2, 0)

N = 1000;
xi = gpc_sample(V, N);
plot(xi(1,:), xi(2,:), 'x')

n = state.num_vars;
u = zeros(n, N);
for i=1:N
   p = xi(:, i);
    u(:,i) = electrical_network_solve(state, p);
end

fprintf('u_%d = %5.3g +- %5.3g\n', [1:n; mean(u, 2)'; std(u, [], 2)']);


for i=1:n
    for j=1:n
        if i==j
            continue
        end
        subplot(n, n, i+(j-1)*n);
        plot(u(i,:), u(j,:), 'x')
        xlim([.22,.39]);
        ylim([.22,.39]);
    end
end




