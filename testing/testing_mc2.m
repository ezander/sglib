state = electrical_network_init();

V = {'pp', multiindex(2, 0)};

N = 1000;
n = state.num_vars;
u_mean = [];
u_var = [];
for i=1:N
    % p = gpc_sample(V, 'rand', @rand);
    p = gpc_sample(V);
    u = electrical_network_solve(state, p);
    [u_mean, u_var] = mean_var_update(i, u, u_mean, u_var);
end

fprintf('u_%d = %5.3g +- %5.3g\n', [1:n; u_mean'; sqrt(u_var)']);

