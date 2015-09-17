function unittest_pce_pdf_1d
% UNITTEST_PCE_PDF_1D Test the PCD_CDF_1D function.
%
% Example (<a href="matlab:run_example unittest_pce_pdf_1d">run</a>)
%   unittest_pce_pdf_1d
%
% See also PCD_CDF_1D, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'pce_pdf_1d' );

%X_alpha=[30, 12, 1];


% Test exact with shifted normal distribution
X_alpha=[30, 2, 0];
I_X=multiindex(1, 2);

xi = linspace(23, 35, 50);
y=pce_pdf_1d(xi, X_alpha, I_X );
y_ex=normal_pdf(xi, 30, 2);
assert_equals(y, y_ex, 'shifted');

%% Test exact with chisquared distribution
X_alpha=[1, 0, 1];
I_X=multiindex(1, 2);
xi = [-1, linspace(0, 5, 20)];
xi = 0;
y=pce_pdf_1d(xi, X_alpha, I_X );
y_ex=chisquared_pdf(xi,1);
assert_equals(y, y_ex, 'chisquared');

%% Test with highly expanded lognormal distribution
deg=18;
X_alpha = pce_expand_1d(@exp, deg);
I_X=multiindex(1, deg);

xi = linspace(-1, 5, 30);
y=pce_pdf_1d(xi, X_alpha, I_X );
y_ex=lognormal_pdf(xi,0,1);
assert_equals(y, y_ex, 'lognorm', 'abstol', 1e-5);

