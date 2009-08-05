function [xd,wd] = full_tensor_grid( d, stages, oned_rule_func )
% FULL_TENSOR_GRID Return nodes and weights for full tensor product grid.
%
% Example (<a href="matlab:run_example tensor_mesh">run</a>)
%   [xd,wd]=full_tensor_grid( 2, 7, @gauss_hermite_rule );
%   subplot(2,2,1); plot(xd(1,:),xd(2,:),'*k')
%   [xd,wd]=full_tensor_grid( [], [3 9], @gauss_hermite_rule );
%   subplot(2,2,2); plot(xd(1,:),xd(2,:),'*k')
%   [xd,wd]=full_tensor_grid( [], 5, {@gauss_hermite_rule; @gauss_legendre_rule}  );
%   subplot(2,2,3); plot(xd(1,:),xd(2,:),'*k')
%   [xd,wd]=full_tensor_grid( [], [6 6 3], {@gauss_hermite_rule; @gauss_legendre_rule; @clenshaw_curtis_legendre_rule}  );
%   subplot(2,2,4); plot3(xd(1,:),xd(2,:),xd(3,:),'*k')
%
% See also SMOLYAK_GRID, TENSOR_MESH

%   Andreas Keese, Elmar Zander
%   Copyright 2006,2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% if parameters missing or singleton replace with correct/repeated values
if isempty(d)
    d=max( length(stages), size(oned_rule_func,1) );
end
if length(stages)==1
    stages=repmat(stages,d,1);
end
if ~iscell(oned_rule_func)
    oned_rule_func=repmat({oned_rule_func},d,1);
elseif size(oned_rule_func,1)==1
    oned_rule_func=repmat(oned_rule_func,d,1);
end

% check dimension consistency
if d~=size(oned_rule_func,1)
    error( 'Dimension d doesn''t match that of the cell array of rules functions.' );
end
if d~=size(oned_rule_func,1)
    error( 'Dimension d doesn''t match that of the array of number of stages.' );
end

% get all 1d rules
x1 = cell( d, 1 );
w1 = cell( d, 1 );
for k = 1:d
    [x1{k},w1{k}] = funcall( oned_rule_func{k,:}, stages(k) );
end

% create tensor mesh
[xd,wd] = tensor_mesh( x1, w1 );
