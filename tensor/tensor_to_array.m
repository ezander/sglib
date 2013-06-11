function t=tensor_to_array(T)
% TENSOR_TO_ARRAY Short description of tensor_to_array.
%   TENSOR_TO_ARRAY Long description of tensor_to_array.
%
% Example (<a href="matlab:run_example tensor_to_array">run</a>)
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

d=tensor_size(T);

t=tensor_to_vector(T);
t=reshape(t,d);
