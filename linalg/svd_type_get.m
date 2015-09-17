function type=svd_type_get( S )
% SVD_TYPE_GET Get type of SVD according to the middle argument.
%   TYPE=SVD_TYPE_GET(S) returns the type of SVD given the middle argument
%   S. If the SVD is of the form U*S*V', i.e. S is a diagonal matrix, then
%   TYPE='matrix' is returned. If the middle argument is a vector
%   containing only the singular values (i.e. the SVD is U*diag(S)*V'),
%   then TYPE='vector' is returned. If the middle argument is empty (i.e.
%   the decomposition is U*V'), the TYPE='emtpy' is returned.
%
% Example (<a href="matlab:run_example svd_type_get">run</a>)
%   [U, S, V] = svd(rand(10,13));
%   disp(svd_type_get(S))
%   disp(svd_type_get(diag(S)))
%   disp(svd_type_get([]))
%
% See also SVD, SVD_ADD, SVD_UPDATE, SVD_TYPE_SET

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


if isempty(S)
    type='empty';
elseif isvector(S)
    type='vector';
else
    type='matrix';
end
