function func=make_spatial_function(func_str)
% MAKE_SPATIAL_FUNCTION Short description of make_spatial_function.
%   MAKE_SPATIAL_FUNCTION Long description of make_spatial_function.
%
% Example (<a href="matlab:run_example make_spatial_function">run</a>)
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

func={@spatial_function, {func_str}, {1}};
