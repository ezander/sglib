function surr_model = generate_surrogate_model(model, Q, p, method, method_params)

num_params = Q.num_params();
num_vars = model.response_dim();

spectral_model = spmodel_init(num_params, num_vars, 'solve_func', @solve_with_model);
spectral_model.model = model;

V_q = Q.get_germ();
V_u = gpcbasis_modify(V_q, 'p', p);
func = funcreate(['compute_response_surface_' method]);
[u_i_alpha, ~]=funcall(func, spectral_model, @(xi)(Q.germ2params(xi)), V_u, method_params{:});

%[u_i_alpha, ~]=compute_response_surface_projection(spectral_model, @(xi)(Q.germ2params(xi)), V_u, 3, 'grid', 'full_tensor');
% [u_mean, u_var] = multivector_map(@(coeffs)(gpc_moments(coeffs, V_u)), u_i_alpha);
% model.plot_all(u_mean)
% model.plot_all(u_var)

surr_model = SurrogateModel(u_i_alpha, V_u, Q, model);


function [u, solve_info, spec_model]=solve_with_model(spec_model, q, model, varargin)
model = spec_model.model;
u = model.compute_response(q);
solve_info=struct();
