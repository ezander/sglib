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


%% uniform_cdf
munit_set_function('uniform_cdf');
a=2; b=4;
assert_equals( uniform_cdf(1.9,a,b), 0, 'cdf_smaller' );
assert_equals( uniform_cdf(2.5,a,b), 1/4, 'cdf_inside' );
assert_equals( uniform_cdf(5,a,b), 1, 'cdf_larger' );
assert_equals( uniform_cdf((a+b)/2,a,b), 1/2, 'cdf_median' );

% default arguments
x = linspace(-1.1, 2.3);
assert_equals( uniform_cdf(x), uniform_cdf(x,0,1), 'cdf_def12' );
assert_equals( uniform_cdf(x,-0.2), uniform_cdf(x,-0.2,1), 'cdf_def2' );


%% uniform_pdf
munit_set_function('uniform_pdf');
assert_equals( uniform_pdf(-inf,a,b), 0, 'pdf_minf' );
assert_equals( uniform_pdf(3.5,a,b), 1/2, 'pdf_inside' );
assert_equals( uniform_pdf(inf,a,b), 0, 'pdf_inf' );

% pdf matches cdf
[x2,x1]=linspace_midpoints( -0.1, 5 );
F=uniform_cdf( x1, a,b );
F2=pdf_integrate( uniform_pdf( x2, a,b ), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );

% default arguments
x = linspace(-1.1, 2.3);
assert_equals( uniform_pdf(x), uniform_pdf(x,0,1), 'pdf_def12' );
assert_equals( uniform_pdf(x,-0.2), uniform_pdf(x,-0.2,1), 'pdf_def2' );


%% uniform_invcdf
munit_set_function( 'uniform_invcdf' );

y = linspace(0, 1);

params = {};
x = linspace(0, 1);
assert_equals( uniform_cdf(uniform_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_1');
assert_equals( uniform_invcdf(uniform_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_1');
assert_equals( isnan(uniform_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');

params = {0.5};
x = linspace(0.5, 1);
assert_equals( uniform_cdf(uniform_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_2');
assert_equals( uniform_invcdf(uniform_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_2');
assert_equals( isnan(uniform_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan2');

params = {-2, 3};
x = linspace(-2, 3);
assert_equals( uniform_cdf(uniform_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_3');
assert_equals( uniform_invcdf(uniform_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_3');
assert_equals( isnan(uniform_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan3');


%% uniform_stdnor
munit_set_function( 'uniform_stdnor' );
N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

params={0.2,1.3};
x=uniform_stdnor( gam, params{:} );
assert_equals( uniform_cdf(x, params{:}), uni, 'uniform' )
assert_equals( uniform_stdnor(gam), uniform_stdnor(gam, 0, 1), 'uniform_def12');
assert_equals( uniform_stdnor(gam, 0), uniform_stdnor(gam, 0, 1), 'uniform_def2');

%% uniform_raw_moments
munit_set_function( 'uniform_raw_moments' );

% some precomputed moments
expected=[ 1.0, 0.5, 0.33333333333333331, 0.25, 0.20000000000000001, ...
    0.16666666666666666, 0.14285714285714285, 0.125, 0.1111111111111111, ...
    0.10000000000000001, 0.090909090909090912];
assert_equals( expected, uniform_raw_moments( 0:10, 0, 1 ), 'a0b1' );

  
expected=[ 1.0, 2.6000000000000001, 7.1633333333333331, ...
    20.722000000000001, 62.349620000000009, 193.5102866666667];
assert_equals( expected(1+[3,1,5])', uniform_raw_moments( [3;1;5], 1.5, 3.7 ), 'a15b37' );

expected=[ 1, 2, 4, 8, 16];
assert_equals( expected, uniform_raw_moments( 0:4, 2, 2 ), 'a2b2' );

% limit case for a==b
assert_equals( uniform_raw_moments(0:5, 3, 3), 3.^(0:5), 'limit_a_eq_b');

% test default arguments
assert_equals( uniform_raw_moments(0:5), uniform_raw_moments(0:5, 0, 1), 'def_12');
assert_equals( uniform_raw_moments(0:5, 0.3), uniform_raw_moments(0:5, 0.3, 1), 'def_2');

