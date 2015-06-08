function unittest_chisquared_distribution
% UNITTEST_CHISQUARED_DISTRIBUTION Test the distribution functions.
%
% Example (<a href="matlab:run_example unittest_chisquared_distribution">run</a>)
%    unittest_chisquared_distribution
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

%% chisquared_cdf
munit_set_function('chisquared_cdf');
k=6;
assert_equals( chisquared_cdf(-inf,k), 0, 'cdf_minf' );
assert_equals( chisquared_cdf(-1e8,k), 0, 'cdf_negative' );
assert_equals( chisquared_cdf(inf,k), 1, 'cdf_inf' );
assert_equals( chisquared_cdf(k*(1-2/(9*k))^3,k), 1/2, 'cdf_approx_median', 'abstol', 0.0012 );

%% chisquared_pdf
munit_set_function('chisquared_pdf');
k=5;
assert_equals( chisquared_pdf(-inf,k), 0, 'pdf_minf' );
assert_equals( chisquared_pdf(-1e8,k), 0, 'pdf_negative' );
assert_equals( chisquared_pdf(1e400,k), 0, 'pdf_near_inf' );
assert_equals( chisquared_pdf(inf,k), 0, 'pdf_inf' );

% pdf matches cdf
[x1,x2]=linspace_mp(0.1,10);
F=chisquared_cdf(x1, k);
F2=pdf_integrate( chisquared_pdf(x2,k), F, x1);
assert_equals( F, F2, 'pdf_cdf_match', struct('abstol',0.01) );


%% chisquared_invcdf
munit_set_function( 'chisquared_invcdf' );

y = linspace(0, 1);
x = linspace(0, 10);

params = {6};
assert_equals( chisquared_cdf(chisquared_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_1');
assert_equals( chisquared_invcdf(chisquared_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_1');
assert_equals( isnan(chisquared_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan1');

params = {0.1};
assert_equals( chisquared_cdf(chisquared_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_2');
assert_equals( chisquared_invcdf(chisquared_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_2');
assert_equals( isnan(chisquared_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan2');

params = {50};
assert_equals( chisquared_cdf(chisquared_invcdf(y, params{:}), params{:}), y, 'cdf_invcdf_3');
assert_equals( chisquared_invcdf(chisquared_cdf(x, params{:}), params{:}), x, 'invcdf_cdf_3');
assert_equals( isnan(chisquared_invcdf([-0.1, 1.1], params{:})), [true, true], 'invcdf_nan3');



%% chisquared_moments
munit_set_function( 'chisquared_moments' );
[m,v,s,k]=chisquared_moments(8);
assert_equals([m,v,s,k], [8,16,1,3/2], 'k8');
[m,v,s,k]=chisquared_moments(10);
assert_equals([m,v,s,k], [10,20,sqrt(0.8),1.2], 'k10');


%% chisquared_sample
munit_set_function( 'chisquared_sample' );

munit_control_rand('seed' );

assert_equals(size(chisquared_sample(100,8)), [100,1], 'size_vec');
assert_equals(size(chisquared_sample([27,13],8)), [27,13], 'size_mat');
assert_equals(size(chisquared_sample([2,3,5,7],8)), [2,3,5,7], 'size_ten');

x=chisquared_sample(100000,8);
assert_equals(mean(x), 8, 'approx_mean', 'abstol', 0.03);
assert_equals(var(x), 16, 'approx_var', 'abstol', 0.1);

