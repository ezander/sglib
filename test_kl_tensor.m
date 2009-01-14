function test_kl_tensor
% TEST_KL_TENSOR Test the KL_TO_TENSOR and TENSOR_TO_KL functions.
%
% Example 
%    test_kl_tensor
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


% Test KL_TO_TENSOR
assert_set_function( 'kl_to_tensor' );

mu_r_j=(1:5)';
r_j_i=(6:10)';
rho_i_alpha=(11:20);

R=kl_to_tensor( mu_r_j, r_j_i, rho_i_alpha );
R_ex={[1:5;6:10]',[1,zeros(1,9);11:20]'};
assert_equals( R, R_ex, 'R' );


% Test TENSOR_TO_KL
assert_set_function( 'tensor_to_kl' );

R={[1:5;6:10]',[1,zeros(1,9);11:20]'};
mu_r_j_ex=(1:5)'+11*(6:10)';
r_j_i_ex=(6:10)';
rho_i_alpha_ex=[0, 12:20];

[mu_r_j, r_j_i, rho_i_alpha]=tensor_to_kl( R );
assert_equals( mu_r_j, mu_r_j_ex, 'mu' );
assert_equals( r_j_i, r_j_i_ex, 'r_i' );
assert_equals( rho_i_alpha, rho_i_alpha_ex, 'rho_i' );


% Test both KL_TO_TENSOR and TENSOR_TO_KL
mu_r_j_ex=rand(50,1);
r_j_i_ex=rand(50,7);
rho_i_alpha_ex=[zeros(7,1), rand(7,60)];

R_ex=kl_to_tensor( mu_r_j_ex, r_j_i_ex, rho_i_alpha_ex );
[mu_r_j, r_j_i, rho_i_alpha]=tensor_to_kl( R_ex );
R=kl_to_tensor( mu_r_j, r_j_i, rho_i_alpha );

assert_equals( mu_r_j, mu_r_j_ex, 'R2' );
assert_equals( mu_r_j, mu_r_j_ex, 'mu2' );
assert_equals( r_j_i, r_j_i_ex, 'r_i2' );
assert_equals( rho_i_alpha, rho_i_alpha_ex, 'rho_i2' );
