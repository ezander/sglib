function unittest_stdnor
% UNITTEST_STDNOR Test the STDNOR function.
%
% Example (<a href="matlab:run_example unittest_stdnor">run</a>)
%   unittest_stdnor
%
% See also STDNOR, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


N=50;
uni=linspace(0,1,N+2)';
uni=uni(2:end-1);
gam=sqrt(2)*erfinv(2*uni-1);

% normal distribution
munit_set_function( 'normal_stdnor' );
params={.2,.3};
x=normal_stdnor( gam, params{:} );
assert_equals( normal_cdf(x, params{:}), uni, 'normal' )

% lognormal distribution
munit_set_function( 'lognormal_stdnor' );
params={.2,.3};
x=lognormal_stdnor( gam, params{:} );
assert_equals( lognormal_cdf(x, params{:}), uni, 'lognormal' )

% exponential distribution
munit_set_function( 'exponential_stdnor' );
params={.7};
x=exponential_stdnor( gam, params{:} );
assert_equals( exponential_cdf(x, params{:}), uni, 'exponential' )

% beta distribution
munit_set_function( 'beta_stdnor' );
params={.5,1.3};
x=beta_stdnor( gam, params{:} );
assert_equals( beta_cdf(x, params{:}), uni, 'beta' )

% uniform distribution
munit_set_function( 'uniform_stdnor' );
params={0.2,1.3};
x=uniform_stdnor( gam, params{:} );
assert_equals( uniform_cdf(x, params{:}), uni, 'uniform' )

