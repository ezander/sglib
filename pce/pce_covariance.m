function C_r=pce_covariance( r_i_alpha, I_r )
% PCE_COVARIANCE Computes the covariance between variables in a PC expansion.
%   C_R=PCE_COVARIANCE( R_I_ALPHA, I_R ) computes the covariances between
%   each pair of sets of coefficients given in R_I_ALPHA. I_R contains the
%   multiindices of the multivariate Hermite polynomials.
%
% See also GPC_COVARIANCE, PCE_MOMENTS

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

V_r = gpcbasis_create('H', 'I', I_r);
C_r = gpc_covariance(r_i_alpha, V_r);
