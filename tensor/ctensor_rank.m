function r=ctensor_rank(T)
% CTENSOR_RANK Returns the numerical rank of the given CP tensor.
%   R=CTENSOR_RANK(T) returns the numerical rank R of the tensor, if the
%   tensor is in canonical format. If T is a full tensor, we get an upper
%   limit by reshaping it into a matrix (if its a higher order tensor) and
%   then returning the matrix rank.
%
% Example (<a href="matlab:run_example ctensor_rank">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_tensor_format( T );

r=size(T{1},2);
