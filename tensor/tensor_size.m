function s=tensor_size(T, contract)
% TENSOR_SIZE Returns the size of the tensor.
%   S=TENSOR_SIZE(T) returns the size of the tensor T in the vector S. If
%   the tensor if of order D>=2, then S has length D. Only for order 0 or 1
%   S has always length 2;
%
%   S=TENSOR_SIZE(T, TRUE) returns the linear size of the tensor T in S. If
%   the tensor has order D>=2, the product of the dimensions is returned,
%   such that S always is a scalar.
%
% Example (<a href="matlab:run_example tensor_size">run</a>)
%   T = rand(3,5,7);
%   tensor_size(T)
%   T = {rand(3,10), rand(5,10), rand(7,10)};
%   tensor_size(T)
%   tensor_size(T, true)
%   T = tensor_to_vector(T);
%   tensor_size(T)
%
% See also TENSOR_NULL, TENSOR_TO_VECTOR

%   Elmar Zander
%   Copyright 2010-2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<2
    contract=false;
end

if isnumeric(T)
    s=size(T);
elseif is_ctensor(T)
    s=ctensor_size(T);
elseif isobject(T)
    s=size(T); % class must have overwritten the size function
else
    error( 'sglib:param_error', ...
        'input parameter is no recognized tensor format' );
end

if contract
    s=prod(s);
end
