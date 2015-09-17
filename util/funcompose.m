function func=funcompose(func1, func2)
% FUNCOMPOSE Returns the composition of two functions.
%   FUNCOMPOSE Long description of funcompose.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example funcompose">run</a>)
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

func = funcreate(@composed_function, func1, func2, @funarg);

function z=composed_function(func1, func2, x)
y = funcall(func1, x);
z = funcall(func2, y);
