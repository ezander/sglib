function str=operator_type(A)
% OPERATOR_TYPE Short description of operator_type.
%   OPERATOR_TYPE Long description of operator_type.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example operator_type">run</a>)
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

if isnumeric(A)
    str = 'matrix';
elseif is_func_operator(A)
    str = 'linop';
elseif is_tensor_operator(A)
    str = 'tensorop';
end

    