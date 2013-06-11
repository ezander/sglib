function bool=check_tensor_operator_format(A,max_order)
% CHECK_TENSOR_OPERATOR_FORMAT Short description of check_tensor_operator_format.
%   CHECK_TENSOR_OPERATOR_FORMAT Long description of check_tensor_operator_format.
%
% Example (<a href="matlab:run_example check_tensor_operator_format">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<2
    max_order=inf;
end

if ~iscell(A) 
    error( 'tensor:param_error', ...
        'input parameter is no recognized tensor operator format (no cell)' );
end

if size(A,2)>max_order
    error( 'tensor:param_error', ...
        'order of tensor operator too large for called function (max: %d)', max_order );
end

% TODO: we currently don't check sizes of operators here, maybe we should, maybe later

