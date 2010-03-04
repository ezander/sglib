function value=get_param(name, default)
% GET_PARAM Short description of get_param.
%   GET_PARAM Long description of get_param.
%
% Example (<a href="matlab:run_example get_param">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

try
    value=evalin( 'caller', name );
catch
    value=default;
end

