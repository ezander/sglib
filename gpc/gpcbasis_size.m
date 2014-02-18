function [m1, m2] = gpcbasis_size(V, dim)
% GPCBASIS_SIZE Return the size of the GPC basis.
%   [NS, M] = GPCBASIS_SIZE(V) returns the number of basis functions NS and
%   the number of random variables M on which the GPC basis V is defined.
%
%   S = GPCBASIS_SIZE(V) returns the size of the basis NS and the
%   number of random variables M on which the GPC basis V is defined in one
%   array S=[NS, M].
%
%   NS = GPCBASIS_SIZE(V, 1) returns the number of basis functions NS and
%   the of the GPC basis V.
%
%   M = GPCBASIS_SIZE(V, 2) returns the number of random variables M on
%   which the GPC basis V is defined.
%
% Example (<a href="matlab:run_example gpcbasis_size">run</a>)
%   V = gpcbasis_create('H', 'm', 4, 'p', 2);
%   fprintf('%d basis functions in %d RVs\n', gpcbasis_size(V,1), gpcbasis_size(V,2));
%   V = gpcbasis_create('hlp', 'p', 6);
%   fprintf('%d basis functions in %d RVs\n', gpcbasis_size(V,1), gpcbasis_size(V,2));
%
% See also GPCBASIS_CREATE, SIZE

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<2
    dim = -1;
end

switch dim
    case 1
        m1 = size(V{2}, 1);
    case 2
        m1 = size(V{2}, 2);
    case -1
        if nargout<2
            m1 = size(V{2});
        else
            [m1, m2] = size(V{2});
        end
    otherwise
        error('sglib:gpc_size', 'Invalid value for input paramter ''dim'' specified: %d', dim);
end   
        