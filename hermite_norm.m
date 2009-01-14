function norm=hermite_norm( pci )
% HERMITE_NORM Compute the norm of multivariate Hermite polynomials.
%  NORM=HERMITE_NORM( PCI ) returns the norms of the multivariate unnormed
%  Hermite polynomials specified by their indices in PCI. Each multiindex
%  has to be a row vector; multiindices can be stacked. The returned vector
%  is a column vector then.
%
% Example
%  % get some multivariate PC expansion somewhere into I_u
%  % where the the coefficients are in u_alpha, then with the 
%  % following you get the coefficients in terms of the normed
%  % Hermite polynomials
%  norm_alpha=hermite_norm(I_u);
%  u_alpha_normed = row_col_mult( u_alpha, norm_alpha );
%
% See also HERMITE_VAL, MULTIINDEX, MULTIINDEX_FACTORIAL, ROW_COL_MULT

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


norm=sqrt( multiindex_factorial( pci ) );
