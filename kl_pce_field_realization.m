function [u_x,xi]=kl_pce_field_realization( x, mu_u, v_u, u_i_alpha, I_alpha, xi, varargin )
% KL_PCE_FIELD_REALIZATION Compute a realization of a random field given by a
% KL and PCE.
%   [U_X,XI]=KL_PCE_FIELD_REALIZATION( X, MU_U, V_U, U_I_ALPHA, I_U, XI )
%   computes a realization of the field at the nodes given in X (i.e.
%   X(i,:) is point x_i) using the KL eigenfunction V_U where the random
%   variables corresponding to V_U(i) have a PC expansion with coefficients
%   in U_I_ALPHA (U_I_ALPHA(:,i) are the coefficients for eigenfunction
%   V_U(I,:)) and multiindices of the expansion given in I_ALPHA. If XI is
%   specified this XI is used, otherwise a normal random vector is
%   generated. MU_U is the mean value of the field If no output argument is
%   specified the realiziation is plotted. Otherwise the field is returned
%   in U_X. XI may also be returned, which may be interesting if it was
%   generated inside.

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
xi_i=hermite_val_multi( u_i_alpha, I_alpha, xi );

% compute values of the random variables of the KL
u_x=repmat(mu_u,1,size(xi_i,1)) + v_u*xi_i';

if nargout<1
    plot( x, u_x, plot_options{:} );
end
