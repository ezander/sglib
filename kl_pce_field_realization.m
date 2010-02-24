function [u_i,xi]=kl_pce_field_realization( pos, mu_u_i, u_i_k, u_k_alpha, I_alpha, xi, varargin )
% KL_PCE_FIELD_REALIZATION Compute a realization of a random field given by a
% KL and PCE.
%   [U_I,XI]=KL_PCE_FIELD_REALIZATION( POS, MU_U_I, U_I_K, U_K_ALPHA, I_U, XI )
%   computes a realization of the field at the nodes given in X (i.e.
%   X(i,:) is point x_i) using the KL eigenfunction U_I_K where the random
%   variables corresponding to U_I_K(i) have a PC expansion with coefficients
%   in U_K_ALPHA (U_K_ALPHA(:,k) are the coefficients for eigenfunction
%   U_I_K(I,:)) and multiindices of the expansion given in I_ALPHA. If XI is
%   specified this XI is used, otherwise a normal random vector is
%   generated. MU_U_I is the mean value of the field If no output argument is
%   specified the realiziation is plotted. Otherwise the field is returned
%   in U_I. XI may also be returned, which may be interesting if it was
%   generated inside.
%
% Hint: The dimensions of the parameters must be such that 
%    POS * MU_U_I
%    POS * U_I_K * U_K_ALPHA * I_ALPHA * XI
%   are well-defined matrix products.
%

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[plot_options,options]=get_option( options, 'plot_options', {} );
check_unsupported_options( options, mfilename );


m=size(I_alpha,2);

if nargin<6 || isempty(xi)
    xi=randn(1,m);
end

% compute values of the random variables of the KL
xi_k=pce_evaluate( u_k_alpha, I_alpha, xi );

% compute values of the random variables of the KL
u_i=repmat(mu_u_i,1,size(xi_k,2)) + u_i_k*xi_k;

if nargout<1
    plot( pos, u_i, plot_options{:} );
end
