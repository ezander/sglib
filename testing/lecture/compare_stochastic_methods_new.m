%% Init stuff

init_func = @electrical_network_init;
solve_func = @electrical_network_solve;
polysys = 'p';

%% Monte Carlo

N = 100;
[u_mean, u_var] = compute_moments_mc(init_func, solve_func, polysys, N);
show_mean_var('Monte-Carlo', u_mean, u_var)

%% Quasi Monte Carlo

[u_mean, u_var] = compute_moments_mc(init_func, solve_func, polysys, N, 'mode', 'qmc');
show_mean_var('Quasi Monte-Carlo', u_mean, u_var)

%% Latin hypercube

[u_mean, u_var] = compute_moments_mc(init_func, solve_func, polysys, N, 'mode', 'lhs');
show_mean_var('Latin hypercube', u_mean, u_var)

%% Direct integration full tensor grid

p = 5;
[u_mean, u_var] = compute_moments_quad(init_func, solve_func, polysys, p, 'grid', 'full_tensor');
show_mean_var('Full tensor grid integration', u_mean, u_var);

%% Direct integration sparse grid

p = 5;
[u_mean, u_var] = compute_moments_quad(init_func, solve_func, polysys, p, 'grid', 'smolyak');
show_mean_var('Sparse grid (Smolyak) integration', u_mean, u_var);




%% Projection
polysys = 'pH';
polysys = 'hu';
polysys = 'h';

p_u = 3;
p_int = 5;

V_u = gpcbasis_create(polysys, 'm', 2, 'p', p_u);
u_i_alpha = compute_response_surface_projection(init_func, solve_func, V_u, p_int);

[u_mean, u_var] = gpc_moments(u_i_alpha, V_u);
show_mean_var('Projection (L_2, response surface)', u_mean, u_var);


% Plot the response surface
N=20;
%plot_response_surface(V_u, u_i_alpha(1,:), N, 'delta', 0.01);
%plot_response_surface(V_u, u_i_alpha(1,:), N, 'delta', 0.01, 'surf_color', 'pdf', 'pdf_plane', 'none');
plot_response_surface(V_u, u_i_alpha(1,:), N, 'delta', 0.01, 'surf_color', 'pdf');


%% Full tensor grid collocation (interpolation)


%% Sparse grid collocation (regression)

%% Non-intrusive Galerkin

