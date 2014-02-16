function t=ctensor_to_array(T)
% CTENSOR_TO_ARRAY Short description of ctensor_to_array.
%   CTENSOR_TO_ARRAY Long description of ctensor_to_array.
%
% Example (<a href="matlab:run_example ctensor_to_array">run</a>)
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

d=ctensor_size(T);

t=ctensor_to_vector(T);
t=reshape(t,d);
