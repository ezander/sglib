function unittest_uniform_distribution
% UNITTEST_UNIFORM_DISTRIBUTION Test the distribution functions.
%
% Example (<a href="matlab:run_example unittest_uniform_distribution">run</a>)
%    unittest_uniform_distribution
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


%% Uniform distribution
a=2; b=4;
munit_set_function('uniform_cdf');
assert_equals( uniform_cdf(1.9,a,b), 0, 'cdf_smaller' );
assert_equals( uniform_cdf(2.5,a,b), 1/4, 'cdf_inside' );
assert_equals( uniform_cdf(5,a,b), 1, 'cdf_larger' );
assert_equals( uniform_cdf((a+b)/2,a,b), 1/2, 'cdf_median' );

munit_set_function('uniform_pdf');
assert_equals( uniform_pdf(-inf,a,b), 0, 'pdf_minf' );
assert_equals( uniform_pdf(3.5,a,b), 1/2, 'pdf_inside' );
assert_equals( uniform_pdf(inf,a,b), 0, 'pdf_inf' );

[x1,x2]=linspace_mp( -0.1, 5 );
F=uniform_cdf( x1, a,b );
F2=pdf_integrate( uniform_pdf( x2, a,b ), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );


%% uniform_stdnor
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

munit_set_function( 'uniform_stdnor' );
params={0.2,1.3};
x=uniform_stdnor( gam, params{:} );
assert_equals( uniform_cdf(x, params{:}), uni, 'uniform' )
assert_equals( uniform_stdnor(gam), uniform_stdnor(gam, 0, 1), 'uniform_def12');
assert_equals( uniform_stdnor(gam, 0), uniform_stdnor(gam, 0, 1), 'uniform_def2');
