function unittest_gendist
% UNITTEST_GENDIST Test the GENDIST function.
%
% Example (<a href="matlab:run_example unittest_gendist">run</a>)
%   unittest_gendist
%
% See also GENDIST, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gendist' );

% first test without shift and scaling
x=linspace(-10,10,1000);
y=linspace(0.01,0.99,1000);
mom_ex=cell(1,4);
mom_ac=cell(1,4);
assert_equals( gendist_pdf(x, {'beta', {4,2}}), beta_pdf( x, 4, 2), 'beta_pdf' );
assert_equals( gendist_cdf(x, {'normal', {1,3}}), normal_cdf( x, 1, 3), 'normal_cdf' );
assert_equals( gendist_invcdf(y, {'normal', {1,3}}), normal_invcdf( y, 1, 3), 'normal_invcdf' );
assert_equals( gendist_stdnor(x, {'lognormal', {0,2}}), lognormal_stdnor( x, 0, 2), 'lognormal_stdnor' );
[mom_ac{:}]=gendist_moments({'exponential', {4}});
[mom_ex{:}]=exponential_moments(4);
assert_equals( cell2mat(mom_ac), cell2mat(mom_ex), 'exponential_moments' );

% Old style conventions
warn_state = warning('off', 'sglib:statistics:gendist');
assert_equals( gendist_pdf(x, 'beta', {4,2}), beta_pdf( x, 4, 2), 'beta_pdf_old_style' );
warning(warn_state);

% test shifting and scaling with normal distribution
dist = {'normal', {0, 1}, 1.2, 3.7};
assert_equals( gendist_pdf(x, dist), normal_pdf( x, 1.2, 3.7), 'shift_normal_pdf' );
assert_equals( gendist_cdf(x, dist), normal_cdf( x, 1.2, 3.7), 'shift_normal_cdf' );
assert_equals( gendist_invcdf(y, dist), normal_invcdf( y, 1.2, 3.7), 'shift_normal_invcdf' );
assert_equals( gendist_stdnor(x, dist), normal_stdnor( x, 1.2, 3.7), 'shift_normal_stdnor' );
[mom_ac{:}]=gendist_moments(dist);
[mom_ex{:}]=normal_moments(1.2, 3.7);
assert_equals( cell2mat(mom_ac), cell2mat(mom_ex), 'shift_normal_moments' );

% second test shifting and scaling 
dist = {'normal', {1, 2}, 2.5, 3};
assert_equals( gendist_pdf(x, dist), normal_pdf( x, 3.5, 6), 'shift_normal_pdf2' );
assert_equals( gendist_cdf(x, dist), normal_cdf( x, 3.5, 6), 'shift_normal_cdf2' );
assert_equals( gendist_invcdf(y, dist), normal_invcdf( y, 3.5, 6), 'shift_normal_invcdf2' );
assert_equals( gendist_stdnor(x, dist), normal_stdnor( x, 3.5, 6), 'shift_normal_stdnor2' );
[mom_ac{:}]=gendist_moments(dist);
[mom_ex{:}]=normal_moments(3.5, 6);
assert_equals( cell2mat(mom_ac), cell2mat(mom_ex), 'shift_normal_moments2' );

% test internal consistency of shifting and scaling with beta distribution
x=linspace(-10,10,10000);
h=x(2)-x(1);
dist = {'beta', {2.5, 3.7}, 1.3, 4.6};
pdf=gendist_pdf(x, dist);
cdf=gendist_cdf(x, dist);
% -> test that pdf is the derivative of cdf
assert_equals( sum((diff(cdf)-h*0.5*(pdf(2:end)+pdf(1,end-1))).^2), 0, 'l2_pdf_cdf', 'abstol', 2e-4 );
% -> test that cdf is inverse of invcdf (xi must be inside range of beta
% values)
xi=linspace(0.13,3.6,10000);
assert_equals( gendist_invcdf(gendist_cdf(xi, dist), dist), xi, 'l2_invcdf_cdf');
assert_equals( gendist_cdf(gendist_invcdf(y, dist), dist), y, 'l2_cdf_invcdf');

% test moments by integration of x^n over pdf
[mean,var,skew,kurt]=gendist_moments({'beta', {2.5, 3.7}, 1.3, 4.6});
mean_pdf=sum(h*x.*pdf);
assert_equals( mean, mean_pdf, 'mean_pdf');
var_pdf=sum(h*(x-mean).^2.*pdf);
assert_equals( var, var_pdf, 'var_pdf');
skew_pdf=sum(h*((x-mean)/sqrt(var)).^3.*pdf);
assert_equals( skew, skew_pdf, 'skew_pdf', 'abstol', 1e-6 );
kurt_pdf=sum(h*((x-mean)/sqrt(var)).^4.*pdf)-3;
assert_equals( kurt, kurt_pdf, 'kurt_pdf', 'abstol', 1e-6 );

% test that cdf(stdnor()) is cdf of normal dist
x=linspace(-7,7,1000);
dist = gendist_create('beta', {2.5, 3.7}, 'shift', 1.3, 'scale', 4.6);
stdnor=gendist_stdnor(x, dist);
y=gendist_cdf(stdnor, dist);
assert_equals( y, normal_cdf(x), 'cdf_stdnor_beta' );

dist = gendist_create('normal');
y=gendist_stdnor(x, dist);
assert_equals( y, x, 'cdf_stdnor_normal' );

dist = gendist_create('chisquared', {3});
stdnor=gendist_stdnor(x, dist);
y=gendist_cdf(stdnor, dist);
assert_equals( y, normal_cdf(x), 'cdf_stdnor_chi' );



% Tests with objects
x=linspace(-10,10,1000);
y=linspace(0.01,0.99,1000);
% mom_ex=cell(1,4);
% mom_ac=cell(1,4);
B = BetaDistribution(4, 2);
assert_equals( gendist_pdf(x, B), beta_pdf( x, 4, 2), 'beta_pdf_object' );
assert_equals( gendist_cdf(x, B), beta_cdf( x, 4, 2), 'beta_cdf_object' );
assert_equals( gendist_invcdf(y, B), beta_invcdf( y, 4, 2), 'beta_invcdf_object' );
assert_equals( gendist_stdnor(x, B), beta_stdnor( x, 4, 2), 'beta_stdnor_object' );


for i=1:4
    mom_ex=cell(1,i);
    mom_ac=cell(1,i);
    [mom_ac{:}]=gendist_moments(B);
    [mom_ex{:}]=beta_moments(4, 2);
    assert_equals( cell2mat(mom_ac), cell2mat(mom_ex), 'beta_moments_objects' );
end
