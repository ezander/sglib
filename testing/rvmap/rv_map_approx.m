function rv_map_approx


Nx = 3;
V_x=gpcbasis_create('H', 'm', 4, 'p', 2);
x_i_alpha = gpc_rand_coeffs(V_x, Nx);

Ny = 2;
V_y=gpcbasis_create('H', 'm', 4, 'p', 3);
y_j_beta = gpc_rand_coeffs(V_y, Ny);

p_phi = 3;
p_int = 6;

[V_phi, phi_j_gamma]=approx_rvmap(y_j_beta, V_y, x_i_alpha, V_x, p_phi, p_int);

%% show difference between approximations

xi = gpc_sample(V_x);
x = gpc_evaluate(x_i_alpha, V_x, xi);
y = gpc_evaluate(y_j_beta, V_y, xi);

y_approx = gpc_evaluate(phi_j_gamma, V_phi, x);
underline('difference for one sample');
fprintf('y_%d: %6.4f  approx: %6.4f diff: %6.4f \n', [(1:Ny)', y, y_approx, abs(y-y_approx)]');


%% approximate L2 error of approximation by MC (LHS) sampling
N=1000;
[y_relerr, xi] = compute_mc_error(y_j_beta, V_y, x_i_alpha, V_x, phi_j_gamma, V_phi, N);
plot(xi(3,:), xi(4,:), '.')
underline('L2 error');
fprintf('relerr y_%d: %6.4f%%\n', [(1:Ny)', y_relerr*100]');

