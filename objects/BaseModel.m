classdef BaseModel < handle
    % BASEMODEL Base class for stochastic Models.
    methods (Abstract)
        n=response_dim(model);
        u=compute_response(model, q);
        y=compute_measurements(model, u);
    end
end
