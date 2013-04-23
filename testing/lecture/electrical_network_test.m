% initialise the state of the electrical network
state = electrical_network_init('R', 0.02, 'f0', 0.1);
% display the state
state

% get the number of parameters from the state and set to some random value
p = rand(state.num_params, 1);
% get a starting vector from the state 
u = state.u0;
% compute the residual for the starting vector and the given state
r = electrical_network_residual(state, u, p);
norm(r)


% solve the system with a nonlinear solver based on Picard iterations
u = state.u0;
max_iter = 100;
abstol = 1e-5;

for iter = 1:max_iter
    r = electrical_network_residual(state, u, p);
    fprintf( 'iter %d, norm=%g\n', iter, norm(r));
    if norm(r)<abstol
        break;
    elseif iter==max_iter
        error('solve:no_conv', ...
            'Could not reach convergence (abstol=%g) in %d iterations', ...
            abstol, max_iter);
    end
    
    u = u + r;
end
    

% the same as before, but solver has been put into the function
% 'nonliner_solve_picard' and the residual computation function had been
% changed to a parameter
residual_func = @electrical_network_residual;
u0 = 0.01*rand(size(state.u0));
u2 = nonlinear_solve_picard(residual_func, state, p, 'u0', u0);

% compare both solutions (inline solver and function)
norm(u-u2)


