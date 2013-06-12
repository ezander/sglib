function cov=rational_quadratic_covariance(alpha, x1, x2, l, sigma, smooth)
% RATIONAL_QUADRATIC_COVARIANCE Compute the rational quadratic covariance function.
%   C=RATIONAL_QUADRATIC_COVARIANCE(ALPHA, X1, X2, L, SIGMA) computes the
%   rational quadratic covariance between points given in X1 and X2. If X2
%   is empty it is assumed that X1 only contains distances. Otherwise, X1
%   and X2 can contain lists of points, where the first index in X1/X2
%   corresponds to the number of the point and the second index to the
%   dimension, i.e. X1(i,:) is a row vector containing the coordinates of
%   point x_i. If L or SIGMA are not given they are both assumed to be 1.
%
%   The rational quadratic covariance functions is given by:
%     $$C(d) = \Bigg(1+\frac{d^2}{2\alpha l^2}\Bigg)^{-\alpha}$$
%
% References:
%   [1] C. E. Rasmussen & C. K. I. Williams, Gaussian Processes for Machine
%       Learning, the MIT Press, 2006, ISBN 026218253X.
%       http://www.gaussianprocess.org/gpml/chapters/RW4.pdf‎
%   [2] http://en.wikipedia.org/wiki/Rational_quadratic_covariance_function
%
% Example (<a href="matlab:run_example rational_quadratic_covariance">run</a>)
%   x1=rand(10,2);
%   x2=rand(10,2);
%   c=rational_quadratic_covariance( 1, x1, x2, 0.2, 1 );
%
%   x=sqrspace(-2,2,100,4);
%   clf;
%   subplot(2, 1, 1);
%   hold all
%   alpha=1;
%   plot(x, rational_quadratic_covariance(alpha, x, [], 0.5, 0.5 ));
%   plot(x, rational_quadratic_covariance(alpha, x, [], 0.3, 0.5 ));
%   plot(x, rational_quadratic_covariance(alpha, x, [], 0.2, 0.5 ));
%   plot(x, rational_quadratic_covariance(alpha, x, [], 0.1, 0.5 ));
%   title('Rational quadratic covariance (alpha=1)');
%   legend('\sigma=0.5, l=0.5', '\sigma=0.5, l=0.3', '\sigma=0.5, l=0.2', '\sigma=0.5, l=0.1');
%   hold off
%
%   subplot(2, 1, 2);
%   hold all
%   plot(x, rational_quadratic_covariance(0.15, x, [], 0.5, 0.5 ));
%   plot(x, rational_quadratic_covariance(0.3, x, [], 0.5, 0.5 ));
%   plot(x, rational_quadratic_covariance(0.5, x, [], 0.5, 0.5 ));
%   plot(x, rational_quadratic_covariance(1, x, [], 0.5, 0.5 ));
%   plot(x, rational_quadratic_covariance(2, x, [], 0.5, 0.5 ));
%   plot(x, rational_quadratic_covariance(30, x, [], 0.5, 0.5 ));
%   title('Rational quadratic covariance (\sigma=0.5, l=0.5)');
%   legend('alpha=0.15', 'alpha=0.3', 'alpha=0.5', 'alpha=1', 'alpha=2', 'alpha=30');
%   hold off
%
%
% See also GAUSSIAN_COVARIANCE, MATERN_COVARIANCE, COVARIANCE_MATRIX

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

% Check that the parameter alpha is within range
check_boolean(alpha>0, 'input argument "alpha" must be positive', mfilename);

d=scaled_distance(x1, x2, l, smooth);
cov = sigma^2 * (1 + d.^2 / (2 * alpha)) .^ (-alpha);


