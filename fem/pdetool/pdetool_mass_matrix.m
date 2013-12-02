function G=pdetool_mass_matrix(pos, els)
% PDETOOL_MASS_MATRIX Compute mass matrix using the PDE Toolbox.
%   G=PDETOOL_MASS_MATRIX(POS, ELS) computes the mass matrix from the
%   mesh specified in POS and ELS using the PDE Toolbox.
%
% Notes:
%   This function is only available if the PDE Toolbox is available and on
%   the matlab path.
%
% Example (<a href="matlab:run_example pdetool_mass_matrix">run</a>)
%   [pos,els]=load_pdetool_geom('circle', 'numrefine', 2);
%   G=pdetool_mass_matrix(pos, els);
%   spy(G)
%
% See also PDETOOL_STIFFNESS_MATRIX

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

p=pos;
t=[els; zeros(1, size(els,2))];
[K,G]=assema(p,t,0,1,0);
swallow(K);
