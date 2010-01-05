function U=tensor_scale( T, alpha )
% TENSOR_SCALE Scale a sparse tensor product by a scalar.
%   U=TENSOR_SCALE( T, ALPHA ) returns mathematically ALPHA*T.
%
% Example (<a href="matlab:run_example tensor_scale">run</a>)
%   T={rand(8,2), rand(10,2)}
%   U=tensor_scale(T,3)
%
% See also TENSOR_NULL, TENSOR_ADD

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

if alpha==0 % yep, exact test for floating points is ok here
    % If scale if zero we can save space by returning a real null tensor
    U=tensor_null(T);
elseif isfull(T)
    U=alpha*T;
elseif iscanonical(T)
    % Important: apply alpha only to one argument! This guy is a tensor not
    % a cartesian product.
    U=T;
    U{1}=alpha*T{1};
else
    error( 'tensor:tensor_scale:param_error', ...
        'input parameter is no recognized tensor format' );   
end
