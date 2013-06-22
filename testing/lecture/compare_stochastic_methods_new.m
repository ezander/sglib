%% Init stuff

init_func = @electrical_network_init;
solve_func = @electrical_network_solve;
polysys = 'p';

%% Monte Carlo

N = 100;
[u_mean, u_var] = compute_moments_mc(init_func, solve_func, polysys, N);
show_mean_var('Monte-Carlo', u_mean, u_var)

%% Quasi Monte Carlo

% not yet, need invcdf for that

%% Direct integration full grid

p = 5;
[u_mean, u_var] = compute_moments_quad(init_func, solve_func, polysys, p, 'grid', 'full_tensor');
show_mean_var('Full tensor grid integration', u_mean, u_var);

%% Direct integration sparse grid

p = 5;
[u_mean, u_var] = compute_moments_quad(init_func, solve_func, polysys, p, 'grid', 'smolyak');
show_mean_var('Sparse grid (Smolyak) integration', u_mean, u_var);

%% Projection
p_u = 3;
p_int = 5;
[u_i_alpha, V_u] = compute_response_surface_projection(init_func, solve_func, polysys, p_u, p_int);

%%
V_u = gpcbasis_create(polysys, 'm', 2, 'p', p_u);
u_i_alpha = compute_response_surface_projection(init_func, solve_func, V_u, p_int);

[u_mean, u_var] = gpc_moments(u_i_alpha, V_u);
show_mean_var('Projection (L_2, response surface)', u_mean, u_var);

%%
theta = gpc_sample(V_u, 1000);
val = gpc_evaluate(u_i_alpha, V_u, theta);
plot3(theta(1,:), theta(2,:), val(1,:), '.')



%% Galerkin


%% Full tensor grid interpolation


%% Sparse grid regression

