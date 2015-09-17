function U=tensor_scale( T, alpha )
% TENSOR_SCALE Scale a tensor by a scalar.
%   U=TENSOR_SCALE( T, ALPHA ) returns mathematically ALPHA*T.
%
% Example (<a href="matlab:run_example tensor_scale">run</a>)
%   T={rand(8,2), rand(10,2)}
%   U=tensor_scale(T,3)
%
% See also TENSOR_NULL, TENSOR_ADD

%   Elmar Zander
%   Copyright 2007-2014, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if alpha==0 % Yes, exact test for floating points is ok here!
    % If scale is zero we can for some tensor formats save space by
    % returning a real null vector
    U=tensor_null(T);
elseif isnumeric(T)
    U=alpha*T;
elseif is_ctensor(T)
    U=ctensor_scale(T,alpha);
elseif isobject(T)
    U=alpha*T;
else
    error( 'sglib:tensor_scale:param_error', ...
        'input parameter is no recognized tensor format' );   
end
