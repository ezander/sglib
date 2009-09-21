function plotnd( n, dim, xd )
% PLOTND Short description of plotnd.
%   PLOTND Long description of plotnd.
%
% Example (<a href="matlab:run_example plotnd">run</a>)
%
% See also

%   <author>
%   Copyright 2009, <institution>
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

subplot(2,2,n); 
if dim==2
    plot(xd(1,:),xd(2,:),'*k');
else
    plot3(xd(1,:),xd(2,:),xd(3,:),'*k');
end
