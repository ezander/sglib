function v=tensor_to_vector(T)
% TENSOR_TO_VECTOR Short description of tensor_to_vector.
%   TENSOR_TO_VECTOR Long description of tensor_to_vector.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example tensor_to_vector">run</a>)
%
% See also

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
        'input parameter is no recognized vector format or formats don''t match' );
end
