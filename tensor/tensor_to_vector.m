function v=tensor_to_vector(T)
% TENSOR_TO_VECTOR Convert a tensor into a vector.
%   V=TENSOR_TO_VECTOR(T) converts the tensor T into a vector V. If T is
%   already a vector, the output remains unchanged. If T is a matrix or
%   higher dimensional array, the result is obtained by stacking its
%   columns. For other types of tensors the appropriate function is called
%   to first transform it into an equivalent vector or matrix form and then
%   stack it if necessary.
%
% Example (<a href="matlab:run_example tensor_to_vector">run</a>)
%   % create a ctensor and transform to a vector
%   T = {[1;2], [3;5]};
%   tensor_to_vector(T)
%
% See also TENSOR_TO_ARRAY

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isnumeric(T)
    v = T(:);
elseif is_ctensor(T)
    v=ctensor_to_vector(T);
elseif isobject(T)
    v = full(T);
    v = v(:);
else
    error( 'sglib:tensor_to_vector:param_error', ...
        'input parameter is no recognized tensor format or formats don''t match' );
end
