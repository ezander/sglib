function S=gaussian_spectral_density(xi, l_c, d)
% GAUSSIAN_SPECTRAL_DENSITY Computes the spectral density for a Gaussian covariance.
%   GAUSSIAN_SPECTRAL_DENSITY(XI, L_C, D) computes the spectral density
%   for an isotropic Gaussian covariance of the form EXP(-(X/L_C)^2) in D
%   dimensions.
%   GAUSSIAN_SPECTRAL_DENSITY(XI, L_C, D) computes the spectral density
%   for the 1D case.
%
% Note:
%   The underlying covariance functions (sometimes also called the squared
%   exponential covariance) is often given in the form EXP(-(X/L_C)^2/2).
%   In the form used here you would have to replace L_C by L_C*SQRT(2).
%
% Example (<a href="matlab:run_example gaussian_spectral_density">run</a>)
%   multiplot_init(1,2)
%   x = linspace(-2,2,101); xi=linspace(-2,2,101);
%   for l_c = [0.1, 0.2, 0.5, 1.0]
%       multiplot; hold all; title('Covariance');
%       plot(x, gaussian_covariance(x, [], l_c)); legend_add(l_c)
%       multiplot; hold all; title('Spectral density');
%       plot(xi, gaussian_spectral_density(xi, l_c, 1)); legend_add(l_c)
%   end
%   
% See also GAUSSIAN_COVARIANCE, KD_FOURIER, MATERN_SPECTRAL_DENSITY, EXPONENTIAL_SPECTRAL_DENSITY

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3 || isempty(d)
    d = size(xi,1);
end

r2 = sum(xi.^2, 1);
S = (l_c^2*pi)^(d/2) * exp(-pi^2  * l_c^2 * r2);
