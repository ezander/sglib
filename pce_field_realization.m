function [u_i,xi]=pce_field_realization( pos, u_i_alpha, I_alpha, xi, varargin )
% PCE_FIELD_REALIZATION Compute a realization of a random field given by a
% PCE alone.
%   [U_X,XI]=PCE_FIELD_REALIZATION( X, U_I_ALPHA, I_ALPHA, XI ) computes a realization
%   of the field at the nodes given in X (i.e. X(i,:) is point x_i) using
%   the PC expansion with coefficients in U_I_ALPHA (U(:,i) are the
%   coefficients for point x_i) and multiindices of the expansion given in
%   I_ALPHA. If XI is specified this XI is used, otherwise a normal random
%   vector is generated (XI must be a row vector).
%   If no output argument is specified the realiziation is plotted.
%   Otherwise the field is returned in U_X. XI may also be returned, which
%   may be interesting if it was generated inside.
%
% Hint: The dimensions of the parameters must be such that 
%    POS * U_I_ALPHA * I_ALPHA * XI
%   is a well-defined matrix product.
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

if nargin<4 || isempty(xi)
    xi=randn(m,1);
end

u_i=pce_evaluate( u_i_alpha, I_alpha, xi );

if nargout<1
    plot( pos, u_i, plot_options{:} );
end
