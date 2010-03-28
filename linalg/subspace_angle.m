function theta=subspace_angle(A1,A2)
% SUBSPACE_ANGLE Short description of subspace_angle.
%   SUBSPACE_ANGLE Long description of subspace_angle.
%
% Example (<a href="matlab:run_example subspace_angle">run</a>)
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
C=Q1'*Q2;
s=svd(C);
theta=acos(s);

