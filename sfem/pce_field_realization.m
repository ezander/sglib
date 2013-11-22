function [u_i,xi]=pce_field_realization( u_i_alpha, I_alpha, xi )
% PCE_FIELD_REALIZATION Compute a realization of a random field given by a
% PCE alone.
%   [U_X,XI]=PCE_FIELD_REALIZATION( U_I_ALPHA, I_ALPHA, XI ) computes a realization
%   of the field using
%   the PC expansion with coefficients in U_I_ALPHA (U(:,i) are the
%   coefficients for point x_i) and multiindices of the expansion given in
%   I_ALPHA. If XI is specified this XI is used, otherwise a normal random
%   vector is generated (XI must be a row vector).
%   The field is returned in U_X. XI may also be returned, which
%   may be interesting, if it was generated inside.
%
% Hint: The dimensions of the parameters must be such that 
%      U_I_ALPHA * I_ALPHA * XI
%   is a well-defined matrix product.
%

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

check_match( u_i_alpha, I_alpha, false, 'u_i_alpha', 'I_alpha', mfilename );
m=size(I_alpha,2);

if nargin<3 || isempty(xi)
    xi=randn(m,1);
end

u_i=pce_evaluate( u_i_alpha, I_alpha, xi );
