function unittest_pce_moments
% UNITTEST_PCE_MOMENTS Test the PCE_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_pce_moments">run</a>)
%    unittest_pce_moments
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'pce_moments' );

pcc=[4 0.3 0 0];
pci=[0 1 2 3]';

[mu,sig2,skew]=pce_moments( pcc );
assert_equals( [mu,sig2,skew], [4,0.09,0], 'moments_onearg' );

[mu,sig2,skew]=pce_moments( pcc, pci );
assert_equals( [mu,sig2,skew], [4,0.09,0], 'moments_twoarg' );

[mu,sig2,skew]=pce_moments( pcc, [pci zeros(4,1)]);
assert_equals( [mu,sig2,skew], [4,0.09,0], 'moments_twoarg' );


pcc=[4 0.3 0 0; 2 1 1 0];
pci=[0 1 2 3]';

[mu,sig2,skew]=pce_moments( pcc, [pci zeros(4,1)]);
assert_equals( [mu,sig2,skew], [4,0.09,0;2,3,14/(3*sqrt(3))], 'moments_mult' );



% from old unittest_moments
mu=-1;
sigma=1;
p=9;
h={@lognormal_stdnor,{mu,sigma}};
pcc=pce_expand_1d(h,p);
[me,ve,se]=lognormal_moments( mu, sigma );
[mp,vp,sp]=pce_moments( pcc );
assert_equals( [me,ve,se], [mp,vp,sp], 'pce_lognormal', 'abstol', [1e-8,1e-6,2e-3] );


