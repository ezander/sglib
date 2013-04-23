function [u, iter, res] = nonlinear_solve_picard(residual_func, state, p, varargin)
% NONLINEAR_SOLVE_PICARD Solve nonlinear system iteratively by a simple
% solver based on Picard iterations.

options = varargin2options(varargin);
[u0, options] = get_option(options, 'u0', state.u0);
[max_iter, options] = get_option(options, 'max_iter', 100);
[abstol, options] = get_option(options, 'abstol', 1e-5);
[verbose, options] = get_option(options, 'verbose', false);
check_unsupported_options(options, mfilename);


u = u0;
for iter = 1:max_iter
    r = residual_func(state, u, p);
    res = norm(r);
    if verbose
        fprintf( 'nonlin_solve: iter %d, norm=%g\n', iter, res);
    end
    if norm(res)<abstol
        break;
    elseif iter==max_iter
        error('solve:no_conv', ...
            'Could not reach convergence (abstol=%g) in %d iterations', ...
            abstol, max_iter);
    end
    
    u = u + r;
end
