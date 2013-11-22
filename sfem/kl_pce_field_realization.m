function [u_i,xi]=kl_pce_field_realization( u_i_k, u_k_alpha, I_alpha, xi )
% KL_PCE_FIELD_REALIZATION Compute a realization of a random field given by a
% KL and PCE.
%   [U_I,XI]=KL_PCE_FIELD_REALIZATION( U_I_K, U_K_ALPHA, I_U, XI )
%   computes a realization of the field (i.e.
%   X(i,:) is point x_i) using the KL eigenfunction U_I_K where the random
%   variables corresponding to U_I_K(i) have a PC expansion with coefficients
%   in U_K_ALPHA (U_K_ALPHA(:,k) are the coefficients for eigenfunction
%   U_I_K(I,:)) and multiindices of the expansion given in I_ALPHA. If XI is
%   specified this XI is used, otherwise a normal random vector is
%   generated. The field is returned
%   in U_I. XI may also be returned, which may be interesting, if it was
%   generated inside.
%
% Hint: The dimensions of the parameters must be such that 
%    U_I_K * U_K_ALPHA * I_ALPHA * XI
%   are well-defined matrix products.
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


m=size(I_alpha,2);

if nargin<4 || isempty(xi)
    xi=randn(m,1);
end

% compute values of the random variables of the KL
xi_k=pce_evaluate( u_k_alpha, I_alpha, xi );

% compute values of the random variables of the KL
u_i=u_i_k*xi_k;
