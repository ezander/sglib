state = electrical_network_init();

V = {'p', multiindex(2, 0)};


xw = gpc_integrate([], V, 6, 'grid', 'full_tensor');
%xw = gpc_integrate([], V, 6, 'grid', 'smolyak');
x = xw{1};
w = xw{2};
plot(x(1,:), x(2,:), 'x')
axis square

n = state.num_vars;
u_mean = zeros(n, 1);
u_m2 = zeros(n, 1);

for i=1:length(w)
    p = x(:,i);
    u = electrical_network_solve(state, p);
    
    u_mean = u_mean + w(i) * u;
    u_m2   = u_m2   + w(i) * u.^2;
end
u_var = u_m2 - u_mean.^2;

fprintf('u_%d = %5.3g +- %5.3g\n', [1:n; u_mean'; sqrt(u_var)']);
