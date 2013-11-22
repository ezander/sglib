function unittest_pce_to_kl
% UNITTEST_PCE_TO_KL Test the PCE_TO_KL function.
%
% Example (<a href="matlab:run_example unittest_pce_to_kl">run</a>)
%    unittest_pce_to_kl
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% we don't check directly the result here, but rather some properties
% 1. mean of KL is mean of PCE
% 2. spatial eigenfunctions are orthogonal with norm equal to KL
%    eigenvalues
% 3. stochastic eigenfunction (random vars) are orthogonal
% 4. we get the PCE back from the KL


N=51;
G_N=eye(N);
I_r=multiindex(5,3);
G_X=diag(multiindex_factorial(I_r));
M_r=size(I_r,1);
r_i_alpha=rand(N,M_r);


% return only some eigenfunctions
l_r=7;
[r_i_k, r_k_alpha, sigma_r_k]=pce_to_kl( r_i_alpha, I_r, l_r, [] );
assert_equals( size(r_i_k), [N,l_r+1], 'sizeN' );
assert_equals( size(r_k_alpha), [l_r+1,M_r], 'sizeX' );
%assert_equals( norm((r_i_k*r_k_alpha-r_i_alpha)*G_X,'fro'), relerr, 'pce_back' );
assert_equals( r_i_k(:,2:end)'*G_N*r_i_k(:,2:end), diag(sigma_r_k)^2, 'spat_orth' );
assert_equals( r_k_alpha*G_X*r_k_alpha', eye(l_r+1), 'stoch_orth' );

% return all KL eigenfunctions
[r_i_k, r_k_alpha, sigma_r_k]=pce_to_kl( r_i_alpha, I_r, inf, G_N );
l_r=size(r_i_k,2)-1;

assert_equals( r_i_k(:,1), r_i_alpha(:,1), 'mean' );
assert_equals( r_i_k(:,2:end)'*G_N*r_i_k(:,2:end), diag(sigma_r_k)^2, 'spat_orth' );
assert_equals( r_k_alpha*G_X*r_k_alpha', eye(l_r+1), 'stoch_orth' );
assert_equals( r_i_k*r_k_alpha, r_i_alpha, 'pce_back' );

% with nontrivial spatial Gramian
A=rand(N); A=A'*A;
G_N=(A+A')/2;

[r_i_k, r_k_alpha, sigma_r_k]=pce_to_kl( r_i_alpha, I_r, inf, G_N );
l_r=size(r_i_k,2)-1;

assert_equals( r_i_k(:,1), r_i_alpha(:,1), 'mean' );
assert_equals( r_i_k(:,2:end)'*G_N*r_i_k(:,2:end), diag(sigma_r_k)^2, 'spat_orth' );
assert_equals( r_k_alpha*G_X*r_k_alpha', eye(l_r+1), 'stoch_orth' );
assert_equals( r_i_k*r_k_alpha, r_i_alpha, 'pce_back' );

