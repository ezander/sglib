function V = gpcbasis_create(polysys, varargin)
% GPCBASIS_CREATE Short description of gpcspace_create.
%   GPCSPACE_CREATE Long description of gpcspace_create.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example gpcbasis_create">run</a>)
%
% See also

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

options=varargin2options(varargin);
[m,options]=get_option(options, 'm', @isdefault);
[p,options]=get_option(options, 'p', @isdefault);
[full_tensor,options]=get_option(options, 'full_tensor', false);
check_unsupported_options(options, mfilename);

if isdefault(m)
    m=length(polysys);
end
if isdefault(p)
    p=0;
end
V = {polysys, multiindex(m, p, 'full', full_tensor)};

function b=isdefault(p)
b=isequal(p,@isdefault);
