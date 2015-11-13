function [r_i_j, xi] = gpc_sample(r_i_alpha, V_r, n, varargin)
% GPC_SAMPLE Sample from a GPC.
%   [R_I_J, XI] = GPC_SAMPLE(R_I_ALPHA, V_R, N, OPTIONS) returns samples
%   from the GPC given by R_I_ALPHA and V_R. Samples are from the germ of
%   V_R and then transformed according to the coefficients of the GPC given
%   in R_I_ALPHA. If the GPC has K rows (i.e. represents a K dimensional
%   random variable), then the returned array of samples R_I_J has
%   dimension K x N.
%
% Options
%    Options are directly passed to GPCGERM_SAMPLE, see there.
%
% Example (<a href="matlab:run_example gpc_sample">run</a>)
%    V_r = gpcbasis_create('PP', 'I', [0 0; 1 0; 2 0; 0 1; 0 2; 0 3]);
%    r_i_alpha = [0.5, 0, 1, 0, 0, 0; 0, 0, 0, 1.5, 0, 1];
%    r_i_j = gpc_sample(r_i_alpha, V_r, 100000, 'mode', 'qmc');
%    plot(r_i_j(1,:), r_i_j(2,:), '.', 'MarkerSize', 1)
%
% See also GPCBASIS_CREATE GPCGERM_SAMPLE

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

xi = gpcgerm_sample(V_r, n, varargin{:});
r_i_j = gpc_evaluate(r_i_alpha, V_r, xi);
