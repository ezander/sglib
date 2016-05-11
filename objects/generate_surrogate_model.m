function surr_model = generate_surrogate_model(model, Q, p, method, method_params, varargin)

options=varargin2options(varargin);
[is_xi_stdnor,options]=get_option(options, 'is_xi_stdnor', false);
check_unsupported_options(options,mfilename);

num_params = Q.num_params();
num_vars = model.response_dim();

spectral_model = spmodel_init(num_params, num_vars, 'solve_func', @solve_with_model);
spectral_model.model = model;
if is_xi_stdnor
    xi2params_func=@(xi)(Q.stdnor2params(xi));
else
    xi2params_func=@(xi)(Q.germ2params(xi));
end
if is_xi_stdnor
    syschars=repmat('h',1,num_params);
    V_u=gpcbasis_create(syschars, 'p', p);
else
    V_q = Q.get_germ();
    V_u = gpcbasis_modify(V_q, 'p', p);
end
func = funcreate(['compute_response_surface_' method]);

[u_i_alpha, ~]=funcall(func, spectral_model, xi2params_func, V_u, method_params{:});

surr_model = SurrogateModel(u_i_alpha, V_u, Q, model);


function [u, solve_info, spec_model]=solve_with_model(spec_model, q, model, varargin)
model = spec_model.model;
u = model.compute_response(q);
solve_info=struct();
