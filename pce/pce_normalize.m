function b_i_alpha=pce_normalize( a_i_alpha, I_a, reverse )
% PCE_NORMALIZE Transforms a PCE in unnormed Hermite polys into a PCE in normed Hermite polys.
%   B_I_ALPHA=PCE_NORMALIZE( A_I_ALPHA, I_F ) returns the PC
%   coefficients of the PCE in terms of the normalized Hermite polynomials
%   from the the PCE in terms of the unnormalized Hermite polynomials. This
%   representation has the advantage that the covariance of two Gaussian
%   random variables given in normalized PCE is just the Euclidian product
%   of the coefficient vectors; and the variance of one Gaussian variable
%   is likewise the Euclidian norm.
%   A_I_ALPHA=PCE_NORMALIZE( B_I_ALPHA, I_F, TRUE ) reverses the
%   normalization, i.e. converts to the coefficients of the unnormalized
%   Hermite polynomials again.
%
% Note
%   Most functions of this package currently expect the PCE to be given in
%   unnormalized Hermite polynomials. This has advantages in some areas but
%   disadvantages in others. In the future this might be changed.
%
% Example (<a href="matlab:run_example pce_normalize">run</a>)
%   [a_alpha,I_a]=pce_expand_1d( @(x)(lognormal_stdnor(x,0,1)), 4 );
%   b_alpha=pce_normalize( a_alpha, I_a );
%   [mean_a,var_a]=pce_moments( a_alpha, I_a );
%   mean_b=b_alpha(1);
%   var_b=sum(b_alpha(2:end).^2,2);
%   fprintf('mean: %g==%g\n', mean_a, mean_b);
%   fprintf('var:  %g==%g\n', var_a, var_b);
%
% See also PCE_EXPAND_1D

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


if nargin>2 && reverse
    % here the names are somehow reversed of course
    b_i_alpha=row_col_mult( a_i_alpha, 1./hermite_norm( I_a )' );
else
    b_i_alpha=row_col_mult( a_i_alpha, hermite_norm( I_a )' );
end
