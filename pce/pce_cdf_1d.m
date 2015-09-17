function y=pce_cdf_1d( xi, X_alpha, I_X )
% PCE_CDF_1D Compute cumulative distribution for univariate PCE.
%   Y=PCE_CDF_1D( XI, X_ALPHA, I_X ) computes the cumulative distribution
%   function (CDF) of X_ALPHA at the points XI. This function works only
%   for univariate PCEs, i.e. the PCE may only depend on one Gaussian
%   random variable.
%
% Example (<a href="matlab:run_example pce_cdf_1d">run</a>)
%   % Recover a Chi-squared cdf from a PCE
%   X_alpha=[1, 0, 1];
%   I_X=multiindex(1, 2);
%   xi = linspace(0, 5, 20);
%   y=pce_cdf_1d(xi, X_alpha, I_X );
%   hold off;
%   plot(xi,y); hold all;
%   y=chisquared_cdf(xi,1);
%   plot(xi, y, '-..'); hold off;
%
% See also PCE_PDF_1D

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

V=gpcbasis_create('H', 'I', I_X);
y=gpc_cdf_1d(X_alpha, V, xi);
