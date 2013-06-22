function plot_lines(pos,edges,varargin)
% PLOT_LINES Short description of plot_lines.
%   PLOT_LINES Long description of plot_lines.
%
% Example (<a href="matlab:run_example plot_lines">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[zpos,options]=get_option( options, 'zpos', 0 );
[line_opts,options]=get_option( options, 'line_opts', {} );
check_unsupported_options( options, mfilename );

n=size(edges,2);
X=[pos(1,edges(1,:)); pos(1,edges(2,:)); nan*ones(1,n)];
Y=[pos(2,edges(1,:)); pos(2,edges(2,:)); nan*ones(1,n)];
if size(pos,1)>=3
    Z=[pos(3,edges(1,:)); pos(3,edges(2,:)); nan*ones(1,n)];
else
    if isscalar(zpos)
        Z=zpos*ones(size(X));
    else
        Z=[zpos(edges(1,:)); zpos(edges(2,:)); nan*ones(1,n)];
    end
end
line('xdata', X(:), 'ydata', Y(:), 'zdata', Z(:), line_opts{:} );
