function d=tensor_order(T)
% TENSOR_ORDER Short description of tensor_order.
%   TENSOR_ORDER Long description of tensor_order.
%
% Example (<a href="matlab:run_example tensor_order">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_tensor_format( T );

d=size( T, 2 );
