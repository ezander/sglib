function [xd,wd] = full_tensor_grid( d, stages, oned_rule_func )
% FULL_TENSOR_GRID Return nodes and weights for full tensor product grid.
%   [XD,WD]=FULL_TENSOR_GRID( D, STAGES, ONED_RULE_FUNC ) returns a grid
%   and weights for multidimensional quadrature over tensor product grids.
%   You can have different number of stages (degree, integration points) in
%   each dimension, as well as different 1D integration rules in each
%   dimension. E.g. [XD,WD]=FULL_TENSOR_GRID( 2, [3 5],
%   {@GAUSS_HERMITE_RULE, @GAUSS_LEGENDRE_RULE} ) returns a grid to
%   integrate with a Gauss-Hermite rule with 3 integration points in X
%   direction and with a Gauss-Legendre rule with 5 integration points in Y
%   direction (totalling 15 integration points).
%
%
% Example (<a href="matlab:run_example full_tensor_grid">run</a>)
%   [xd,wd]=full_tensor_grid( 2, 7, @gauss_hermite_rule );
%   subplot(2,2,1); plot(xd(1,:),xd(2,:),'*k')
%   [xd,wd]=full_tensor_grid( [], [3 9], @gauss_hermite_rule );
%   subplot(2,2,2); plot(xd(1,:),xd(2,:),'*k')
%   [xd,wd]=full_tensor_grid( [], 5, {@gauss_hermite_rule; @gauss_legendre_rule}  );
%   subplot(2,2,3); plot(xd(1,:),xd(2,:),'*k')
%   [xd,wd]=full_tensor_grid( [], [6 6 3], {@gauss_hermite_rule; @gauss_legendre_rule; @clenshaw_curtis_nested}  );
%   subplot(2,2,4); plot3(xd(1,:),xd(2,:),xd(3,:),'*k')
%
% See also SMOLYAK_GRID, TENSOR_MESH

%   Andreas Keese, Elmar Zander
%   Copyright 2006,2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% get dimension parameter as max length of either stages or oned_rule_func,
% a 1 indicates the same value should be repeated as appropriate, if both
% are not equal 1 they must be equal to each other (this is checked
% later...)
if isempty(d)
    d=max( length(stages), size(oned_rule_func,1) );
end

% expand stages to array of appropriate size
if length(stages)==1
    stages=repmat(stages,d,1);
elseif length(stages)~=d
    error( 'Dimension d doesn''t match that of the array of number of stages.' );
end

% expand oned_rule_func to cell array of appropriate size
if ~iscell(oned_rule_func)
    oned_rule_func=repmat({oned_rule_func},d,1);
elseif length(oned_rule_func)==1
    oned_rule_func=repmat(oned_rule_func,d,1);
elseif length(oned_rule_func)~=d
    error( 'Dimension d doesn''t match that of the cell array of rules functions.' );
end

% get all 1d rules (i.e. one for each dimension, may of course be all the
% same--usually they are--but can also be different in each dimension)
x1 = cell(d, 1);
w1 = cell(d, 1);
for k = 1:d
    [x1{k},w1{k}] = funcall( oned_rule_func{k}, stages(k) );
end

% create tensor mesh
[xd,wd] = tensor_mesh( x1, w1 );
