function [y,w]=grid_smolyak_rule( N, stages, oned_rule_func )
% SMOLYAK_RULE Return nodes weights for Smolyak quadrature.
%   [Y,W] = SMOLYAK_RULE( N, STAGES, ONED_RULE_FUNC ) returns nodes Y(:,I)
%   and weights W(I) for Smolyak quadrature. N is the dimension of the
%   problem, STAGES is the maximum number of stages in each dimension and
%   ONED_RULE_FUNC is a handle to a function returning the 1d quadrature
%   rules. ONED_RULE_FUNC must be of the signature [X,W]=FUNC( J ) where J
%   is the stage number and X and W are the quadrature points and weights.
%
%   Instead of supplying a function handle you can also directly supply the
%   function with the one dimensional quadrature points and weights for all
%   stages SMOLYAK_RULE( N, stages, [], Y1D, W1D ).
%
% Example (<a href="matlab:run_example grid_smolyak">run</a>)
%   [y,w]=grid_smolyak( 2, 3, @gauss_hermite_rule )
%   subplot 111
%   plot(y(1,:),y(2,:),'*k')
%
% See also

%   Andreas Keese, Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$


n1d = zeros( N, stages );

% For each dimension n obtain all quadrature formulas
% Q^{(n)}_1 \ldots Q^{(n)}_order

y1d = cell( N, stages );
w1d = cell( N, stages );

for n = 1:N
    for j = 1 : stages
        [y1d{n,j},w1d{n,j}] = funcall( oned_rule_func, j );
        n1d(n,j) = length(y1d{n,j});
    end
end

% Construct Smolyak-nodes and weights based on the univariate
% quadrature formulas:
ally = [];
allw = [];

multi_list=multiindex(N,stages-1)+1;

for i = 1 : size(multi_list,1)

    alpha = multi_list(i,:);
    alpha_sum = sum(alpha);

    if alpha_sum < stages
        continue
    end

    tmp_y1d = cell(N,1);
    tmp_w1d = cell(N,1);
    for i = 1 : N
        stage  = alpha(i);
        tmp_y1d{i} = y1d{i,stage};
        tmp_w1d{i} = w1d{i,stage};
    end
    [tmp_y,tmp_w]=grid_tensor_mesh(tmp_y1d,tmp_w1d);

    factor=(-1)^(N+stages-1-alpha_sum) * ...
        nchoosek(N-1,alpha_sum-stages);

    ally=[ally,tmp_y];
    allw=[allw,factor*tmp_w];
end

verbose=false;
if verbose
    printf('Smolyak:')
    printf('type          = %s', typename)
    printf('dimension   N = %d', N)
    printf('order-index l = %d', stages)
    printf('S^N_l #points = %d', length(ally) );
end

y = ally;
w = allw;
