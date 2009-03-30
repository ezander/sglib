function plot_boundary( els, pos, varargin )
%
%
% Example
%
% See also 

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id: plot_field_contour.m 20 2009-03-30 17:03:59Z ezander $ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


check_boolean( size(els,2)==3, 'elements must be triangles (size(els,2)==3)', mfilename );
check_range( size(pos,2), 2, 2, 'sizeof(pos,2)', mfilename );


options=varargin2options( varargin{:} );
[zpos,options]=get_option( options, 'zpos', 0 );
[color,options]=get_option( options, 'color', 'k' );
check_unsupported_options( options, mfilename );

e=[els(:,1), els(:,2); els(:,1), els(:,3); els(:,2), els(:,3)];
e=sort(e,2);
e = sortrows(e);

asnext=all(e(1:end-1,:)==e(2:end,:),2);
bndind=~([0;asnext]|[asnext;0]);
bnd=e(bndind,:);
n=size(bnd,1);
X=[pos(bnd(:,1),1)'; pos(bnd(:,2),1)'; nan*ones(n,1)'];
Y=[pos(bnd(:,1),2)'; pos(bnd(:,2),2)'; nan*ones(n,1)'];
Z=zpos*ones(size(X));
line(X,Y,Z,'color',color);
