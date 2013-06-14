function unittest_normal_distribution
% UNITTEST_NORMAL_DISTRIBUTION Test the distribution functions.
%
% Example (<a href="matlab:run_example unittest_normal_distribution">run</a>)
%    unittest_normal_distribution
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


mu=1; sig=2;
munit_set_function('normal_cdf');
assert_equals( normal_cdf(-inf,mu,sig), 0, 'cdf_minf' );
assert_equals( normal_cdf(inf,mu,sig), 1, 'cdf_inf' );
assert_equals( normal_cdf(mu,mu,sig), 1/2, 'cdf_median' );

munit_set_function('normal_pdf');
assert_equals( normal_pdf(-inf,mu,sig), 0, 'pdf_minf' );
assert_equals( normal_pdf(inf,mu,sig), 0, 'pdf_inf' );

[x1,x2]=linspace_mp(mu-5*sig,mu+5*sig);
F=normal_cdf(x1, mu, sig);
F2=pdf_integrate( normal_pdf(x2,mu,sig), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

%% normal_stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

munit_set_function( 'normal_stdnor' );
params={.2,.3};
x=normal_stdnor( gam, params{:} );
assert_equals( normal_cdf(x, params{:}), uni, 'normal' )
assert_equals( normal_stdnor(gam), normal_stdnor(gam, 0, 1), 'normal_def12');
assert_equals( normal_stdnor(gam, 0), normal_stdnor(gam, 0, 1), 'normal_def2');
