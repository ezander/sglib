function cov=gaussian_covariance(x1, x2, l, sigma, smooth)
% GAUSSIAN_COVARIANCE  Compute the Gaussian covariance function.
%   C=GAUSSIAN_COVARIANCE(X1, X2, L, SIGMA) computes the covariance between
%   points given in X1 and X2. If X2 is empty it is assumed that X1
%   only contains distances. Otherwise, X1 and X2 can contain lists of
%   points, where the first index in X1/X2 corresponds to the number of the
%   point and the second index to the dimension, i.e. X1(i,:) is a row
%   vector containing the coordinates of point x_i. If L or SIGMA are not
%   given they are both assumed to be 1.
%
% Example (<a href="matlab:run_example gaussian_covariance">run</a>)
%   x1=rand(10,2);
%   x2=rand(10,2);
%   c=gaussian_covariance( x1, x2, 0.2, 1 );
%
%   x=sqrspace(-2, 2, 100, 4);
%   clf;
%   subplot(2, 1, 1);
%   hold all
%   plot(x, gaussian_covariance(x, [], 0.5, 0.5));
%   plot(x, gaussian_covariance(x, [], 0.3, 0.5));
%   plot(x, gaussian_covariance(x, [], 0.2, 0.5));
%   plot(x, gaussian_covariance(x, [], 0.1, 0.5));
%   title('Gaussian covariance');
%   legend('\sigma=0.5, l=0.5', '\sigma=0.5, l=0.3', '\sigma=0.5, l=0.2', '\sigma=0.5, l=0.1');
%   hold off
%
%   subplot(2, 1, 2);
%   hold all
%   plot(x, gaussian_covariance( x, [], 0.5, 0.5 ));
%   plot(x, gaussian_covariance( x, [], 0.5, 0.4 ));
%   plot(x, gaussian_covariance( x, [], 0.5, 0.3 ));
%   plot(x, gaussian_covariance( x, [], 0.5, 0.2 ));
%   title('Gaussian covariance');
%   legend('\sigma=0.5, l=0.5', '\sigma=0.4, l=0.5', '\sigma=0.3, l=0.5', '\sigma=0.2, l=0.5');
%   hold off
%
% See also EXPONENTIAL_COVARIANCE, COVARIANCE_MATRIX

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


if nargin<2; x2=[]; end
if nargin<3; l=1; end
if nargin<4; sigma=1; end
if nargin<5; smooth=0; end

dist2=scaled_distance(x1, x2, l, smooth, true);
cov=sigma^2*exp( -dist2 );
