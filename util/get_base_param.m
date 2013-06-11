function value=get_base_param(name, default, ws)
% GET_BASE_PARAM Get parameter from base workspace or default.
%   VALUE=GET_BASE_PARAM(NAME, DEFAULT) returns in VALUE the value that the
%   variable NAME had in the base workspace or DEFAULT if it was not set.
%   This makes it easy for a user to override values that are used for
%   parameters in a function or script, without passing everything
%   explicity.
%   VALUE=GET_BASE_PARAM(NAME, DEFAULT, 'caller') looks for NAME in the
%   workspace the function or script is executing in.
%
% Example (<a href="matlab:run_example get_base_param">run</a>)
%   reltol=get_base_param( 'reltol', 1e-6 );
%   disp(reltol);
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

if nargin<3
    ws='caller';
end

try
    value=evalin( ws, name );
catch
    value=default;
end

