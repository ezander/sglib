classdef SurrogateModel < BaseModel
    % BASEMODEL Base class for stochastic Models.
    properties
        coeffs
        basis@cell
        params@SimParamSet
        orig_model@BaseModel
    end
    
    methods
        function model = SurrogateModel(coeffs, basis, params, orig_model)
            model.coeffs = coeffs;
            model.basis = basis;
            model.params = params;
            model.orig_model = orig_model;
        end
    end
    
    methods (Static)
        function model_by_projection(params, basemodel, p, p_int)
%             V_q = params.get_gpcgerm();
%             V = gpcbasis_create(V_q{1}, 'p', p);
%             [q_i, q_i] = Y_params.integrate(p_int);
%             compute_response_surface_projection(
        end
    end
        
    methods
        function n=response_dim(model)
            n = model.orig_model.response_dim(model);
        end
        function u=compute_response(model, q)
            xi = model.params.params2germ(q);
            func = funcreate(@gpc_evaluate, @funarg, model.basis, xi);
            u = multivector_map(func, model.coeffs);
        end
        
        function y=compute_measurements(model, u)
            y = model.orig_model.compute_measurements(u);
        end
    end
    
end