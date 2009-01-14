function [y,w] = full_tensor_rule( N, stages, oned_rule_func )
% omega_quad_ft_points - return nodes+weights for full tensor quadrature
% 
% [y,w] = omega_quad_ft_points( omega, quad_opts )
%         returns nodes y(:,i) and weights w(i) for an
%         interpolatory in the stochastic space omega of 
%         order 'order'.
%
% This routine is not suited for high-dimensional spaces as it does
% returns the full set of Newton-points.
%
% See 
%  demo_omega_gauss_points.m

% For each dimension n obtain all quadrature formulas
% Q^{(n)}_1 \ldots Q^{(n)}_order

if ~isempty(oned_rule_func)
    y1d = cell( N, 1 );
    w1d = cell( N, 1 );
    for n = 1:N
        [y1d{n},w1d{n}] = funcall( oned_rule_func, stages );
    end
end

[y,w] = tensor_mesh( y1d, w1d );
  
