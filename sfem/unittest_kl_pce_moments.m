function unittest_kl_pce_moments
% UNITTEST_KL_PCE_MOMENTS Test the KL_PCE_MOMENTS function.
%
% Example (<a href="matlab:run_example unittest_kl_pce_moments">run</a>)
%   unittest_kl_pce_moments
%
% See also KL_PCE_MOMENTS, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'kl_pce_moments' );

% we will currently only check against PCE_MOMENTS which should be checked
% before this function here

N=30;
m=5;
p=2;
l=7;
I_r=multiindex(m,p);
M=multiindex_size(m,p);

r_i_k=rand(N,l);
r_k_alpha=rand(l,M);
r_k_alpha(:,1)=0;
% convert to and fro so that we have orthogonal columns
r_i_alpha1=r_i_k*r_k_alpha;
[mu_r_i,r_i_k,sigma_r_k,r_k_alpha]=kl_pce_to_standard_form(r_i_k,r_k_alpha);
[r_i_k,r_k_alpha]=kl_pce_to_compact_form(mu_r_i,r_i_k,sigma_r_k,r_k_alpha);
% compute the pce from the kl/pce
r_i_alpha=r_i_k*r_k_alpha;

[mex,vex]=pce_moments( r_i_alpha, I_r );

[mac,vac]=kl_pce_moments( r_i_k, r_k_alpha, I_r );
assert_equals( mac, mex, 'mean' );
assert_equals( vac, vex, 'var' );

mac=kl_pce_moments( r_i_k, r_k_alpha, I_r );
assert_equals( mac, mex, 'mean2' );



