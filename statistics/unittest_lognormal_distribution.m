function unittest_lognormal_distribution
% UNITTEST_LOGNORMAL_DISTRIBUTION Test the distribution functions.
%
% Example (<a href="matlab:run_example unittest_lognormal_distribution">run</a>)
%    unittest_lognormal_distribution
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


mu=2; sig=0.5;
munit_set_function('lognormal_cdf');
assert_equals( lognormal_cdf(-inf,mu,sig), 0, 'cdf_minf' );
assert_equals( lognormal_cdf(-1e8,mu,sig), 0, 'cdf_negative' );
assert_equals( lognormal_cdf(inf,mu,sig), 1, 'cdf_inf' );
assert_equals( lognormal_cdf(exp(mu),mu,sig), 1/2, 'cdf_median' );

munit_set_function('lognormal_pdf');
assert_equals( lognormal_pdf(-inf,mu,sig), 0, 'pdf_minf' );
assert_equals( lognormal_pdf(-1e8,mu,sig), 0, 'pdf_negative' );
assert_equals( lognormal_pdf(inf,mu,sig), 0, 'pdf_inf' );

[x1,x2]=linspace_mp(0,exp(mu+5*sig));
F=lognormal_cdf(x1, mu, sig);
F2=pdf_integrate( lognormal_pdf(x2,mu,sig), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );
