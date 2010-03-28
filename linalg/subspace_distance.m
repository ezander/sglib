function dist=subspace_distance(A1,A2)
% SUBSPACE_DISTANCE Short description of subspace_distance.
%   SUBSPACE_DISTANCE Long description of subspace_distance.
%
% Example (<a href="matlab:run_example subspace_distance">run</a>)
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

[Q1,R1]=qr(A1,0);
[Q2,R2]=qr(A2,0);
dist=norm(Q1*Q1'-Q2*Q2',2);
