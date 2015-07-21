function [y_j_i] = trig_eval(A_j_k, TB, x_l_i)
% TRIG_EVAL Evaluate the trigonometric expansion of a function.
%   [Y_J_I] = TRIG_EVAL(A_J_K, WP_K_L, X_L_I) evaluate the function
%   represented by the amplitude array A_J_K and the trigonometric basis TB
%   at the point X_L_I. For the meaning of the trig basis TB, please see
%   the help for TRIG_BASIS_EVAL.
%
% Example (<a href="matlab:run_example trig_eval">run</a>)
%     % Trig. approximation of a rect and a sawtooth function
%     TB = {[1,2,3,4,5,6,7]', [0,0,0,0,0,0,0]', [1,1,1,1,1,1,1]'};
%     x = linspace(-0.2,1.2);
%     rect = [1, 0,   1/3,   0, 1/5,   0, 1/7];
%     saw  = [1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7];
%     y = trig_eval([rect; saw], TB, x);
%     plot(x,y); grid on;
%   
% See also TRIG_BASIS_EVAL, FOURIER_SERIES_EXPAND

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

y_k_i = trig_basis_eval(TB, x_l_i);
y_j_i = A_j_k * y_k_i;
