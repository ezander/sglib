function func=make_spatial_func(func_str)
% MAKE_SPATIAL_FUNC Create directly a function handle for a spatial function.
%   FUNC=MAKE_SPATIAL_FUNC(FUNC_STR) creates directly a function handle 
%   for a spatial function that can be evaluated by FUNCALL. 
%
% Example (<a href="matlab:run_example make_spatial_func">run</a>)
%   func = make_spatial_function('x^2+y^2+sin(x*y)');
%   [X, Y] = meshgrid(linspace(-3,3,50));
%   pos = [X(:)'; Y(:)'];
%   x = funcall(func, pos);
%   Z = reshape(z, size(X));
%   surf(X,Y,Z)
%
% See also SPATIAL_FUNCTION

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

func={@spatial_function, {func_str}, {1}};
