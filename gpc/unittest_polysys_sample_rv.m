function unittest_polysys_sample_rv
% UNITTEST_POLYSYS_SAMPLE_RV Test the POLYSYS_SAMPLE_RV function.
%
% Example (<a href="matlab:run_example unittest_polysys_sample_rv">run</a>)
%   unittest_polysys_sample_rv
%
% See also POLYSYS_SAMPLE_RV, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'polysys_sample_rv' );

% setup a defined state for the rng (we use the old syntax to be compatible
% with older versions of matlab, and this is pretty much ok for the use in
% a unit test)

% Tests for sampling are performed by comparing the sampling CDF with the
% analytic CDF 

%%
N = 10000;
y_ex = linspace(0,1,N);

%% Hermite
x = sort(polysys_sample_rv('h', 1, N));
y = (erf(x/sqrt(2))+1)/2;
assert_equals(y, y_ex, 'H_cdf', 'abstol', 5/sqrt(N))
%plot(x,y_ex,x,y);

%% Legendre
x = sort(polysys_sample_rv('p', 1, N));
y = (x+1)/2;
assert_equals(y, y_ex, 'P_cdf', 'abstol', 5/sqrt(N))

%% Chebyshev 1st kind
% CDF see: https://en.wikipedia.org/wiki/Arcsine_distribution
x = sort(polysys_sample_rv('t', 1, N));
y = asin(x)/pi + 0.5;
assert_equals(y, y_ex, 'T_cdf', 'abstol', 5/sqrt(N))

%% Chebyshev 2nd kind
% CDF see: http://en.wikipedia.org/wiki/Wigner_semicircle_distribution
x = sort(polysys_sample_rv('u', 1, N));
y = x.*sqrt(1-x.^2)/pi + asin(x)/pi + 0.5;
assert_equals(y, y_ex, 'U_cdf', 'abstol', 5/sqrt(N))

%% Laguerre
x = sort(polysys_sample_rv('l', 1, N));
y = 1-exp(-x);
assert_equals(y, y_ex, 'L_cdf', 'abstol', 5/sqrt(N))

%% Error handling
assert_error( {@polysys_sample_rv, {'?',1,1}, {1,2,3}}, 'sglib:', 'err_unknown_polys' )
assert_error( {@polysys_sample_rv, {'M',1,1}, {1,2,3}}, 'sglib:', 'err_monomials' )

