function unittest_pce_moments
% UNITTEST_PCE_MOMENTS Test the PCE_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_pce_moments">run</a>)
%    unittest_pce_moments
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


munit_set_function( 'pce_moments' );

% first do it simple: one random variable (size(r_i_alpha,1) in one
% independent Gaussian (size(I_r,2))
r_i_alpha=[4, 0.3, 0, 0];
I_r=[0; 1; 2; 3];

[mu,var,skew]=pce_moments( r_i_alpha, [] );
assert_equals( [mu,var,skew], [4,0.09,0], 'moments_onearg' );

[mu,var,skew]=pce_moments( r_i_alpha, I_r );
assert_equals( [mu,var,skew], [4,0.09,0], 'moments_twoarg' );

% Now in two independent Gaussians ignoring the second
I_r=[0 0; 1 0; 2 0; 3 0];
[mu,var,skew]=pce_moments( r_i_alpha, I_r);
assert_equals( [mu,var,skew], [4,0.09,0], 'moments_two_gauss1' );

% Now in two independent Gaussians ignoring the fist
I_r=[0 0; 0 1; 0 2; 0 3];
[mu,var,skew]=pce_moments( r_i_alpha, I_r);
assert_equals( [mu,var,skew], [4,0.09,0], 'moments_two_gauss2' );

% Now two random vars in one Gaussian
r_i_alpha=[4, 0.3, 0, 0; 
    2, 1, 1, 0];
I_r=multiindex(1,3);

[mu,var,skew]=pce_moments( r_i_alpha, I_r);
assert_equals( [mu,var,skew], [4,0.09,0;2,3,14/(3*sqrt(3))], 'moments_two_rv' );


% Now many random vars in many Gaussians
N=10;
I_r=multiindex(3,4);
r_i_alpha=rand(N, multiindex_size(3,4));
[mu,var]=pce_moments( r_i_alpha, I_r);
mu_ex=r_i_alpha(:,1);
S=r_i_alpha.^2*diag(multiindex_factorial(I_r));
var_ex=sum(S(:,2:end),2);
assert_equals( [mu,var], [mu_ex,var_ex], 'moments_mult_rand' );


%%
r_i_alpha=[4, 0.3, 0.2, 0.1];
I_r=[0; 1; 2; 3];

[mu,var,skew,kurt]=pce_moments( r_i_alpha, I_r );
m0=integrate_central_moment( r_i_alpha, I_r, 0 );
m1=integrate_central_moment( r_i_alpha, I_r, 1 );
m2=integrate_central_moment( r_i_alpha, I_r, 2 );
m3=integrate_central_moment( r_i_alpha, I_r, 3 );
m4=integrate_central_moment( r_i_alpha, I_r, 4 );
assert_equals( [mu,var,skew,kurt], [m1, m2, m3/m2^(3/2), m4/m2^2-3 ], 'moments_onearg' );



%% Check consistency between different algorithms
I_r=multiindex(3,3);
r_i_alpha=rand(10,size(I_r,1));

[mu1,var1,skew1,kurt1]=pce_moments( r_i_alpha, I_r );
[mu3,var3,skew3,kurt3]=pce_moments( r_i_alpha, I_r, 'algorithm', 'pcemult' );
[mu4,var4,skew4,kurt4]=pce_moments( r_i_alpha, I_r, 'algorithm', 'integrate' );

assert_equals( [mu1,var1,skew1,kurt1], [mu3,var3,skew3,kurt3], 'consistency13' );
assert_equals( [mu1,var1,skew1,kurt1], [mu4,var4,skew4,kurt4], 'consistency14' );

% Now we permute I_r and r_i_alpha accordingly and see whether the same
% moments result
mu0=mu1; var0=var1; skew0=skew1; kurt0=kurt1;
perm = randperm(size(I_r,1));
I_r = I_r(perm,:);
r_i_alpha = r_i_alpha(:,perm);
[mu1,var1,skew1,kurt1]=pce_moments( r_i_alpha, I_r );
[mu3,var3,skew3,kurt3]=pce_moments( r_i_alpha, I_r, 'algorithm', 'pcemult' );
[mu4,var4,skew4,kurt4]=pce_moments( r_i_alpha, I_r, 'algorithm', 'integrate' );

assert_equals( [mu0,var0,skew0,kurt0], [mu1,var1,skew1,kurt1], 'perm1' );
assert_equals( [mu0,var0,skew0,kurt0], [mu3,var3,skew3,kurt3], 'perm3' );
assert_equals( [mu0,var0,skew0,kurt0], [mu4,var4,skew4,kurt4], 'perm4' );



function m=integrate_central_moment( r_i_alpha, I_r, p )
p_r=max(multiindex_order(I_r));
if p>=2
    r_i_alpha(:,1)=0;
end
m=integrate_1d( {@kernel,{p,r_i_alpha,I_r},{1,2,3}}, @gauss_hermite_rule, p_r*(1+p) ); 

function val=kernel( p, r_i_alpha, I_r, xi )
val=pce_evaluate(r_i_alpha,I_r,xi);
val=val.^p;
