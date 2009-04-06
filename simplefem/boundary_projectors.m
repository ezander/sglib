function [P_B,P_I]=boundary_projectors( bnd, n )
% BOUNDARY_PROJECTORS Projection matrices on the set of inner and boundary nodes.
%   [P_B,P_I]=BOUNDARY_PROJECTORS( BND, N ) return the projection matrices
%   P_B which projects from N nodes onto the boundary nodes 
%
% Example
%   [P_B,P_I]=boundary_projectors( bnd, n );
%   K\(P_I*f-P_B
;
% 
% See also HERMITE_VAL_MULTI

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

n_B=length(bnd);
n_I=n-n_B;

P_B=sparse( 1:n_B, bnd, ones(n_B,1), n_B, n );

int=ones(n,1);
int(bnd)=0;
int=find(int);
P_I=sparse( 1:n_I, int, ones(n_I,1), n_I, n );
