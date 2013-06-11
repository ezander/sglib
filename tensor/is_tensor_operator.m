function bool=is_tensor_operator(A)
% IS_TENSOR_OPERATOR Short description of is_tensor_operator.
%   IS_TENSOR_OPERATOR Long description of is_tensor_operator.
%
% Example (<a href="matlab:run_example is_tensor_operator">run</a>)
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

bool=false;

if ~iscell(A)
    return;
end

is_linop=cellfun(@isnumeric, A ) | cellfun(@iscell, A );
if ~all(is_linop(:))
    return
end

% we don't do further checking on dimensions, costs too much time
bool=true;


