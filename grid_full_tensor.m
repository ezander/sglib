function [y,w] = grid_full_tensor( N, stages, oned_rule_func )
% GRID_FULL_TENSOR Return nodes and weights for full tensor product grid.
%
% See also

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
  
