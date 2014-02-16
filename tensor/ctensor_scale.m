function U=ctensor_scale( T, alpha )
% CTENSOR_SCALE Scale a sparse tensor product by a scalar.
%   U=CTENSOR_SCALE( T, ALPHA ) returns mathematically ALPHA*T.
%
% Example (<a href="matlab:run_example ctensor_scale">run</a>)
%   T={rand(8,2), rand(10,2)}
%   U=ctensor_scale(T,3)
%
% See also CTENSOR_NULL, CTENSOR_ADD

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_tensor_format( T );

if alpha==0 % yep, exact test for floating points is ok here
    % If scale if zero we can save space by returning a real null tensor
    U=ctensor_null(T);
else
    % Important: apply alpha only to one argument! This guy is a tensor not
    % a cartesian product.
    U=T;
    U{1}=alpha*T{1};
end
