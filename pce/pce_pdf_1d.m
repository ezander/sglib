function y=pce_pdf_1d( xi, X_alpha, I_X )
% PCE_PDF_1D Compute probability distribution for univariate PCE.
%   Y=PCE_PDF_1D( XI, X_ALPHA, I_X ) computes the probablity distribution
%   function (PDF) of X_ALPHA at the points XI. This function works only
%   for univariate PCEs, i.e. the PCE may only depend on one Gaussian
%   random variable.
%
% Example (<a href="matlab:run_example pce_pdf_1d">run</a>)
%   for i=1:2
%     deg=4*i-1;
%     X_alpha = pce_expand_1d(@exp, deg);
%     I_X=multiindex(1, deg);
%     x=linspace(-3,3, 20);
%     subplot(2,2,2*i-1)
%     plot(x, exp(x), x, gpc_evaluate(X_alpha, gpcbasis_create('H', 'I', I_X), x), '-..')
% 
%     xi = linspace(-1, 5, 30);
%     y=pce_pdf_1d(xi, X_alpha, I_X );
%     subplot(2,2,2*i); 
%     plot(xi,y); hold all;
%     y=lognormal_pdf(xi,0,1);
%     plot(xi, y, '-..'); hold off;
%  end
%
% See also PCE_CDF_1D

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

V=gpcbasis_create('H', 'I', I_X);
y=gpc_pdf_1d(X_alpha, V, xi);
