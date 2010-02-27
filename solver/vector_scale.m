function U=vector_scale( T, alpha )
% VECTOR_SCALE Scale a vector by a scalar.
%   U=VECTOR_SCALE( T, ALPHA ) returns mathematically ALPHA*T.
%
% Example (<a href="matlab:run_example vector_scale">run</a>)
%   T={rand(8,2), rand(10,2)}
%   U=vector_scale(T,3)
%
% See also VECTOR_NULL, VECTOR_ADD

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if alpha==0 % Yes, exact test for floating points is ok here!
    % If scale is zero we can for some vector formats save space by
    % returning a real null vector
    U=vector_null(T);
elseif isnumeric(T)
    U=alpha*T;
elseif iscell(T)
    U=tensor_scale(T,alpha);
elseif isobject(T)
    U=alpha*T;
else
    error( 'vector:vector_scale:param_error', ...
        'input parameter is no recognized vector format' );   
end
