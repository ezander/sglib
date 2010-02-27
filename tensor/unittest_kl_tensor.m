function unittest_kl_tensor
% UNITTEST_KL_TENSOR Test the KL_TO_TENSOR and TENSOR_TO_KL functions.
%
% Example (<a href="matlab:run_example unittest_kl_tensor">run</a>)
%    unittest_kl_tensor
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


% Both functions have become trivial by the global change to KL compact
% form. To get the "real" KL you need kl_to_standard_form now.


N=51;
M=56;
L=15;

% Test KL_TO_TENSOR
munit_set_function( 'kl_to_tensor' );

r_i_k=rand(N,L);
r_k_alpha=rand(L,M);

R=kl_to_tensor( r_i_k, r_k_alpha );
assert_equals( R, {r_i_k,r_k_alpha'}, 'R' );


% Test TENSOR_TO_KL
munit_set_function( 'tensor_to_kl' );

R={ r_i_k, r_k_alpha' };
[r_i_k2,r_k_alpha2]=tensor_to_kl( R );
assert_equals( r_i_k2, r_i_k, 'r_i' );
assert_equals( r_k_alpha, r_k_alpha2, 'r_alpha' );
