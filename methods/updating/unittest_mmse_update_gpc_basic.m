function unittest_mmse_update_gpc_basic(varargin)
% UNITTEST_MMSE_UPDATE_GPC_BASIC Test the MMSE_UPDATE_GPC_BASIC function.
%
% Example (<a href="matlab:run_example unittest_mmse_update_gpc_basic">run</a>)
%   unittest_mmse_update_gpc_basic
%
% See also MMSE_UPDATE_GPC_BASIC, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'mmse_update_gpc_basic' );



%munit_control_rand(1234553412345);

% Define the dimensions of the state x, control-input u, and observations z
nx = 5;
nz = 3;

% Define the number of random variables x, w, and v are modelled upon
mx = 6;
mv = 4;

% Now define some random models for them
V_x = gpcbasis_create('P', 'm', mx, 'p', 2);
x_i_alpha = gpc_rand_coeffs(V_x, nx);

V_v = gpcbasis_create('P', 'm', mv, 'p', 1);
v_j_gamma = 10.1 * gpc_rand_coeffs(V_v, nz, 'zero_mean', true);

% Recover the covariance matrices from here
P = gpc_covariance(x_i_alpha, V_x);
R = gpc_covariance(v_j_gamma, V_v);

% Also define some random matrices for the other stuff (i.e. the transition
% matrix F, the observation matrix H, the actual measurement z)
H = randn(nz, nx);
x_true = randn(nx, 1);
z = H * x_true;

%% Now the classical Kalman stuff
%  a) Prediction step (predicted new state xnp and covariance Pnp)

x = gpc_moments(x_i_alpha, V_x);

%  b) Update step (innovation y, innovation covariance S, Kalman gain K,
%  updated state estimate xn, updated covariance Pn)
y = z - H * x;
S = H * P * H' + R;
K = P * H' / S;
xn = x + K * y;
Pn = (eye(nx) - K*H)*P;

%% And now with the MMSE functions on GPC variables

% Define observation model (without the v, that comes extra)
%   z = H * xn
Y_func = @(xi)(H * gpc_evaluate(x_i_alpha, V_x, xi));

% Define error model (must be defined separately from observation model)
V_func = gpc_function(v_j_gamma, V_v);

% Now call the MMSE update procedure
p_phi=1;
p_int_mmse=3;
p_xn=2;
p_int_proj=3;
[xn_i_beta, V_xn]=mmse_update_gpc(x_i_alpha, Y_func, V_x, z, V_func, V_v, p_phi, p_int_mmse, p_xn, p_int_proj);

% Final check of Kalman estimate and covariance update
assert_equals( gpc_moments(xn_i_beta, V_xn), xn, 'updated state estimate xn');
assert_equals( gpc_covariance(xn_i_beta, V_xn), Pn, 'updated covariance estimate Pn');

% [x_mean, x_var]=gpc_moments(xn_i_beta, V_xn);
% [xn_mean, xn_var]=gpc_moments(x_i_alpha, V_x);
% (abs(x_mean-x_true)-abs(xn_mean-x_true)) ./ (0.5 * (x_var+xn_var))
