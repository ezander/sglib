function [xd,wd]=smolyak_grid( d, stages, oned_rule_func, varargin )
% SMOLYAK_GRID Return nodes weights for Smolyak quadrature.
%   [XD,WD] = SMOLYAK_GRID( D, STAGES, ONED_RULE_FUNC ) returns nodes XD(K,:)
%   and weights WD(K) for Smolyak quadrature. D is the dimension of the
%   problem, STAGES is the maximum number of stages in each dimension and
%   ONED_RULE_FUNC (read: 1D_RULE_FUNC) is a handle to a function returning
%   the 1d quadrature rules. ONED_RULE_FUNC must be of the signature
%   [X,W]=FUNC( P ) where P is the stage number and X and W are the
%   quadrature points and weights.
%
%   If you set STAGES to an empty array, ONED_RULE_FUNC can be a vertical
%   cell array of rule functions, one for each dimension. The number of
%   stages is implied by the length of the cell array.
%
% Example (<a href="matlab:run_example smolyak_grid">run</a>)
%   for rule={@gauss_hermite_rule, @gauss_legendre_rule, @clenshaw_curtis_legendre_rule }
%     for i=1:4
%       [xd,wd]=smolyak_grid( 2, 3+i, rule );
%       subplot(2,2,i);
%       plot(xd(1,:),xd(2,:),'*k')
%       subtitle( func2str( rule{1} ), 'interpreter', 'none' );
%     end
%     pause( 2 )
%   end
%
% See also FULL_TENSOR_GRID

%   Andreas Keese, Elmar Zander
%   Copyright 2006, 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[verbose,options]=get_option( options, 'verbose', false );
check_unsupported_options( options, mfilename );


if isempty(d)
    d=size(oned_rule_func,1);
end
if ~iscell(oned_rule_func)
    oned_rule_func=repmat({oned_rule_func},d,1);
elseif size(oned_rule_func,1)==1
    oned_rule_func=repmat(oned_rule_func,d,1);
end

n1d = zeros( d, stages );

% For each dimension n obtain all quadrature formulas
% Q^{(n)}_1 \ldots Q^{(n)}_order

x1 = cell( d, stages );
w1 = cell( d, stages );

for k = 1:d
    for j = 1:stages
        [x1{k,j},w1{k,j}] = funcall( oned_rule_func{k,:}, j );
        n1d(k,j) = length(x1{k,j});
    end
end

% Construct Smolyak-nodes and weights based on the univariate
% quadrature formulas:
xd = [];
wd = [];

multi_list=multiindex(d,stages-1)+1;

for i = 1 : size(multi_list,1)

    alpha = multi_list(i,:);
    alpha_sum = sum(alpha);

    if alpha_sum < stages
        continue
    end

    tmp_x1 = cell(d,1);
    tmp_w1 = cell(d,1);
    for i = 1:d
        stage  = alpha(i);
        tmp_x1{i} = x1{i,stage};
        tmp_w1{i} = w1{i,stage};
    end
    [tmp_yd,tmp_wd]=tensor_mesh(tmp_x1,tmp_w1);

    factor=(-1)^(d+stages-1-alpha_sum) * ...
        nchoosek(d-1,alpha_sum-stages);

    xd=[xd,tmp_yd];
    wd=[wd,factor*tmp_wd];
end

if verbose
    fprintf( 'Smolyak:\n')
    fprintf( 'type          = %s\n', func2str(oned_rule_func{1}))
    fprintf( 'dimension   d = %d\n', d)
    fprintf( 'order-index l = %d\n', stages)
    fprintf( 'S^N_l #points = %d\n', length(wd) );
end

