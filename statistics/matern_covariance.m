function cov=matern_covariance(nu, x1, x2, l, sigma, smooth)
% MATERN_COVARIANCE  Compute the Matern covariance function.
%   C=MATERN_COVARIANCE(NU, X1, X2, L, SIGMA) computes the Matern
%   covariance with parameter NU between points given in X1 and X2. If X2
%   is empty it is assumed that X1 only contains distances. Otherwise, X1
%   and X2 can contain lists of points, where the first index in X1/X2
%   corresponds to the number of the point and the second index to the
%   dimension, i.e. X1(i,:) is a row vector containing the coordinates of
%   point x_i. If L or SIGMA are not given they are both assumed to be 1.
%
%   The matern covariance is given by
%   $$C(d) = \sigma^2 \frac{1}{\Gamma(\nu)2^{\nu-1}}
%     \Bigg(\sqrt{2\nu}d\Bigg)^\nu K_\nu\Bigg(\sqrt{2\nu}d\Bigg)$$
%   where $K_\nu$ is Bessel function of the second kind (in matlab BESSELK)
%   and $d$ is the scaled distance.
%
% References:
%   [1] Minasny, B.; McBratney, AB (2005). "The Matern function as a general
%       model for soil variograms". Geoderma 128: 192-207.
%       doi:10.1016/j.geoderma.2005.04.003.
%   [2] C. E. Rasmussen & C. K. I. Williams, Gaussian Processes for Machine
%       Learning, the MIT Press, 2006, ISBN 026218253X.
%       http://www.gaussianprocess.org/gpml/chapters/RW4.pdf‎
%   [3] http://en.wikipedia.org/wiki/Matern_covariance_function
%
% Example (<a href="matlab:run_example matern_covariance">run</a>)
%   x1=rand(10,2);
%   x2=rand(10,2);
%   c=matern_covariance( 1, x1, x2, 0.2, 1 );
%
%   x=sqrspace(-2,2,100,4);
%   clf;
%   subplot(2, 1, 1);
%   hold all
%   nu=1;
%   plot(x, matern_covariance(nu, x, [], 0.5, 0.5 ));
%   plot(x, matern_covariance(nu, x, [], 0.3, 0.5 ));
%   plot(x, matern_covariance(nu, x, [], 0.2, 0.5 ));
%   plot(x, matern_covariance(nu, x, [], 0.1, 0.5 ));
%   title('Matern covariance (nu=1)');
%   legend('\sigma=0.5, l=0.5', '\sigma=0.5, l=0.3', '\sigma=0.5, l=0.2', '\sigma=0.5, l=0.1');
%   hold off
%
%   subplot(2, 1, 2);
%   hold all
%   plot(x, matern_covariance(0.15, x, [], 0.5, 0.5 ));
%   plot(x, matern_covariance(0.3, x, [], 0.5, 0.5 ));
%   plot(x, matern_covariance(0.5, x, [], 0.5, 0.5 ));
%   plot(x, matern_covariance(1, x, [], 0.5, 0.5 ));
%   plot(x, matern_covariance(2, x, [], 0.5, 0.5 ));
%   plot(x, matern_covariance(30, x, [], 0.5, 0.5 ));
%   title('Matern covariance (\sigma=0.5, l=0.5)');
%   legend('nu=0.15', 'nu=0.3', 'nu=0.5', 'nu=1', 'nu=2', 'nu=30');
%   hold off
%
% See also EXPONENTIAL_COVARIANCE, GAUSSIAN_COVARIANCE, COVARIANCE_MATRIX, BESSELK

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

if nargin<3; x2=[]; end
if nargin<4; l=1; end
if nargin<5; sigma=1; end
if nargin<6; smooth=0; end

% Check that the parameter nu is within range
check_boolean(nu>0, 'input argument "nu" must be positive', mfilename);
if nu>100
    warning('sglib:matern_covariance', 'Matern covariance doesn'' work well with parameter nu>100');
end


d=scaled_distance(x1, x2, l, smooth);

% The general form of the Matern covariance can be found in the references
% given above. However, for d==0 special treatment is necessary, since the
% general expression given 0*infty there.
C1 = 1 / (gamma(nu) * (2^(nu-1)));
C2 = sqrt(2 * nu);
nz = (d~=0.0);
cov = sigma^2 * ones(size(d));
cov(nz) = sigma^2 * C1 * (C2 * d(nz)).^nu .* besselk(nu, C2 * d(nz));
