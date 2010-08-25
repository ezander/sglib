function d=frobenius_inner(A,B)
% FROBENIUS_INNER Short description of frobenius_inner.
%   FROBENIUS_INNER Long description of frobenius_inner.
%
% Example (<a href="matlab:run_example frobenius_inner">run</a>)
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


[r,c,v]=find(A.*B);
swallow(r,c);
d=sum(v);
