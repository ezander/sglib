function norm_I=hermite_norm( I )
% HERMITE_NORM Compute the norm of multivariate Hermite polynomials.
%  NORM_I=HERMITE_NORM( I ) returns the norms of the multivariate unnormed
%  Hermite polynomials specified by the multiindex set I. Multiindices in I
%  need to be a row vector; multiindices can be stacked. The returned vector
%  is a column vector then.
%
% Example (<a href="matlab:run_example hermite_norm">run</a>)
%  I_u=[0 0; 1 1; 2 2; 2 3; 3 3];
%  norm_I_u=hermite_norm(I_u);
%  fprintf('|H_{%1d,%1d}| => %g\n', [I_u norm_I_u]')
%
% See also HERMITE_VAL, MULTIINDEX, MULTIINDEX_FACTORIAL, ROW_COL_MULT

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

norm_I=sqrt( multiindex_factorial( I ) );
