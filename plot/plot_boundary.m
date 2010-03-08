function plot_boundary( pos, els, varargin )
%
%
% Example (<a href="matlab:run_example plot_boundary">run</a>)
%
% See also

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


check_boolean( size(els,1)==3, 'elements must be triangles (size(els,2)==3)', mfilename );
check_range( size(pos,1), 2, 2, 'sizeof(pos,2)', mfilename );

options=varargin2options( varargin );
[zpos,options]=get_option( options, 'zpos', 0 );
[color,options]=get_option( options, 'color', 'k' );
check_unsupported_options( options, mfilename );

bnd=find_boundary( els, false );
n=size(bnd,2);

X=[pos(1,bnd(1,:)), pos(1,bnd(2,:)), nan*ones(1,n)];
Y=[pos(2,bnd(1,:)), pos(2,bnd(2,:)), nan*ones(1,n)];
Z=zpos*ones(size(X));
line(X,Y,Z,'color',color);
