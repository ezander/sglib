function S=matern_spectral_density(nu, xi, l_c, d)
% MATERN_SPECTRAL_DENSITY Short description of matern_spectral_density.
%   MATERN_SPECTRAL_DENSITY(NU, XI, L_C, D) computes the spectral density
%   for an isotropic Matern covariance with parameter NU in dimensions.
%   MATERN_SPECTRAL_DENSITY(NU, XI, L_C, D) computes the spectral density
%   for the 1D case.
%
% References:
%   [1] C. E. Rasmussen & C. K. I. Williams, Gaussian Processes for Machine
%       Learning, the MIT Press, 2006, ISBN 026218253X.
%       http://www.gaussianprocess.org/gpml/chapters/RW4.pdf‎
%
% Example (<a href="matlab:run_example matern_spectral_density">run</a>)
%   multiplot_init(2,2)
%   x = linspace(-3,3,101); xi=linspace(-1,1,101);
%   for nu = [0.3, 2.3]
%       h = multiplot;
%       for l_c = [0.1, 0.2, 0.5, 1.0]
%           multiplot(h); hold all; title(strvarexpand('Covariance ($nu$)'));
%           plot(x, matern_covariance(nu, x, [], l_c)); legend_add(l_c)
%           multiplot; hold all; title(strvarexpand('Spectral density ($nu$)'));
%           plot(xi, matern_spectral_density(nu, xi, l_c, 1)); legend_add(l_c)
%       end
%   end
%   
% See also MATERN_COVARIANCE, KD_FOURIER, EXPONENTIAL_SPECTRAL_DENSITY, GAUSSIAN_SPECTRAL_DENSITY

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

if nargin<4 || isempty(d)
    d = size(xi,1);
end

check_boolean(nu>0, 'input argument "nu" must be positive', mfilename);

r2 = sum(xi.^2, 1);

alpha = 2^d * pi^(d/2) * gamma(nu + d/2) * (2*nu)^(nu);
alpha = alpha / (gamma(nu) * l_c^(2*nu));

S = alpha * (2*nu/l_c^2 + 4*pi^2*r2) .^ -(nu + d/2);
