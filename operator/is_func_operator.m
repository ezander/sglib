function bool = is_func_operator(A)
% IS_FUNC_OPERATOR Short description of is_func_operator.
%   IS_FUNC_OPERATOR Long description of is_func_operator.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example is_func_operator">run</a>)
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

bool = iscell(A) && (numel(A)==3) ... % is a cell array of length 3
        && isnumeric(A{1}) && (numel(A{1})==2) ... % where the first parameter is the size
        && ischar(A{end}) && isequal(A{end}, 'op_marker');

