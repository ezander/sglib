function [els,pos,bnd]=create_mesh_1d( n, x0, x1 )
% CREATE_MESH_1D Creates a 1D mesh for simple finite element calculations.
%   [ELS,POS,BND]=CREATE_MESH_1D( N, X0, X1 ) creates a
%
% Example (<a href="matlab:run_example create_mesh_1d">run</a>)
%   [els,pos,bnd]=create_mesh_1d( 5, 0, 2 );
%   save_format( 'compact', 'short g' );
%   els
%   pos
%   bnd
%   restore_format();
%   clf; dock; func=@cos;
%   plot( pos, func(pos), 'b-x', pos(bnd), func(pos(bnd)), 'rx' );
%
% See also

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

pos=linspace(x0,x1,n)';
els=[1:n-1; 2:n]';
bnd=[1,n];
