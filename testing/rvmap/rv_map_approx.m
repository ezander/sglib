function rv_map_approx

V_xy=gpcbasis_create('H', 'm', 4, 'p', 2);

Nx = 3;
x_i_alpha = gpc_rand_coeffs(V_xy, Nx);

Ny = 2;
y_j_alpha = gpc_rand_coeffs(V_xy, Ny);

p_phi = 3;
p_int = 6;

[V_phi, phi_j_beta]=approx_rvmap(y_j_alpha, x_i_alpha, V_xy, p_phi, p_int);

%% show difference between approximations

xi = gpc_sample(V_xy);
x = gpc_evaluate(x_i_alpha, V_xy, xi);
y = gpc_evaluate(y_j_alpha, V_xy, xi);

y_approx = gpc_evaluate(phi_j_beta, V_phi, x);
underline('difference for one sample');
fprintf('y_%d: %6.4f  approx: %6.4f diff: %6.4f \n', [(1:Ny)', y, y_approx, abs(y-y_approx)]');


%% approximate L2 error of approximation by MC (LHS) sampling
N=1000;
[y_relerr, xi] = compute_mc_error(y_j_alpha, x_i_alpha, V_xy, phi_j_beta, V_phi, N);
plot(xi(3,:), xi(4,:), '.')
underline('L2 error');
fprintf('relerr y_%d: %6.4f%%\n', [(1:Ny)', y_relerr*100]');

1;