function d=ctensor_size(T)
% CTENSOR_SIZE Return the size of the tensor.
%   D=CTENSOR_SIZE(T) Returns the size of the tensor T as an array, i.e. if
%   T is a I1xI2xI3x... tensor then D=[I1,I2,I3,...].
%
% Example (<a href="matlab:run_example ctensor_size">run</a>)
%   T=ctensor_null( [3,4,5] );
%   ctensor_size( T )
%
% See also CTENSOR_NULL

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

check_tensor_format( T );

d=cellfun('size', T, 1 );
