function unittest_pce_cdf_1d
% UNITTEST_PCE_CDF_1D Test the PCE_CDF_1D function.
%
% Example (<a href="matlab:run_example unittest_pce_cdf_1d">run</a>)
%   unittest_pce_cdf_1d
%
% See also PCE_CDF_1D, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'pce_cdf_1d' );

%X_alpha=[30, 12, 1];


%%
X_alpha=[30, 2, 0];
I_X=multiindex(1, 2);

xi = linspace(23, 35, 50);
y=pce_cdf_1d(xi, X_alpha, I_X );
y_ex=normal_cdf(xi, 30, 2);
assert_equals(y, y_ex, 'shifted');

% X_alpha=[30, 2, 0];
% I_X=multiindex(1, 2);
% 
% xi = linspace(29, 32, 20);
% xi = linspace(23, 35, 50);
% y=pce_cdf_1d(xi, X_alpha, I_X );
% hold off;
% plot(xi,y); hold all;
% y=normal_cdf(xi, 30, 2);
% plot(xi, y, '-..');


%%
X_alpha=[1, 0, 1];
I_X=multiindex(1, 2);
xi = linspace(0, 5, 20);
y=pce_cdf_1d(xi, X_alpha, I_X );
y_ex=chisquared_cdf(xi,1);
assert_equals(y, y_ex, 'chisquared');

% X_alpha=[1, 0, 1];
% I_X=multiindex(1, 2);
% 
% xi = linspace(0, 5, 20);
% y=pce_cdf_1d(xi, X_alpha, I_X );
% hold off;
% plot(xi,y); hold all;
% y=chisquared_cdf(xi,1);
% plot(xi, y, '-..');


%%
deg=18;
X_alpha = pce_expand_1d(@exp, deg);
I_X=multiindex(1, deg);

xi = linspace(-1, 5, 30);
y=pce_cdf_1d(xi, X_alpha, I_X );
y_ex=lognormal_cdf(xi,0,1);
assert_equals(y, y_ex, 'lognorm');

% clear
% deg=8;
% X_alpha = pce_expand_1d(@exp, deg);
% I_X=multiindex(1, deg);
% x=linspace(-3,3, 20);
% hold off;
% subplot(2,1,1)
% plot(x, exp(x), x, gpc_evaluate(X_alpha, gpcbasis_create('H', 'I', I_X), x), '-..')
% 
% 
% xi = linspace(-1, 5, 30);
% y=pce_pdf_1d(xi, X_alpha, I_X );
% subplot(2,1,2)
% hold off;
% plot(xi,y); hold all;
% y=lognormal_pdf(xi,0,1);
% plot(xi, y, '-..');

