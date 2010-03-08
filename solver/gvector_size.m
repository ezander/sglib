function d=gvector_size(T)
% GVECTOR_SIZE Short description of gvector_size.
%   GVECTOR_SIZE Long description of gvector_size.
%
% Example (<a href="matlab:run_example gvector_size">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isnumeric(T)
    d=size(T);
elseif is_tensor(T)
    d=tensor_size(T);
elseif isobject(T)
    d=size(T); % class must have overwritten the size function
else
    error( 'vector:param_error', ...
        'input parameter is no recognized vector format' );
end
