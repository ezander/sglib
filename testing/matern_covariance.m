function matern_covariance(varargin)
% MATERN_COVARIANCE Short description of matern_covariance.
%   MATERN_COVARIANCE Long description of matern_covariance.
%
%   $C(d) =
%   \sigma^2\frac{1}{\Gamma(\nu)2^{\nu-1}}\Bigg(2\sqrt{\nu}\frac{d}{\rho}
%   \Bigg)^\nu K_\nu\Bigg(2\sqrt{\nu}\frac{d}{\rho}\Bigg)$
%   (K_\nu Bessel function of the second kind)
%
% References:
%   1. Minasny, B.; McBratney, AB (2005). "The Mat?rn function as a general 
%      model for soil variograms". Geoderma 128: 192?207. 
%      doi:10.1016/j.geoderma.2005.04.003.  edit
%   2. http://en.wikipedia.org/wiki/Mat%C3%A9rn_covariance_function
% Example (<a href="matlab:run_example matern_covariance">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

