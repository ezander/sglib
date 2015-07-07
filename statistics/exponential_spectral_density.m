function S=exponential_spectral_density(xi, l_c, d)
% EXPONENTIAL_SPECTRAL_DENSITY Computes the spectral density for an exponential covariance.
%   EXPONENTIAL_SPECTRAL_DENSITY(XI, L_C, D) computes the spectral density
%   for an isotropic exponential covariance of the form EXP(-X/L_C) in D
%   dimensions.
%   EXPONENTIAL_SPECTRAL_DENSITY(XI, L_C, D) computes the spectral density
%   for the 1D case.
%
% Example (<a href="matlab:run_example exponential_spectral_density">run</a>)
%   multiplot_init(1,2)
%   x = linspace(-3,3,101); xi=linspace(-1,1,101);
%   for l_c = [0.1, 0.2, 0.5, 1.0]
%       multiplot; hold all; title('Covariance');
%       plot(x, exponential_covariance(x, [], l_c)); legend_add(l_c)
%       multiplot; hold all; title('Spectral density');
%       plot(xi, exponential_spectral_density(xi, l_c, 1)); legend_add(l_c)
%   end
%   
% See also EXPONENTIAL_COVARIANCE, KD_FOURIER, MATERN_SPECTRAL_DENSITY, GAUSSIAN_SPECTRAL_DENSITY

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
alpha = (2*l_c)^d * pi^((d-1)/2) * gamma((d+1)/2);

S = alpha * (1 + 4*pi^2*l_c^2*r2) .^ -((d+1)/2);

return

