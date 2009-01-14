function [x,p]=empirical_density(xl,n1,n,varargin)
% EMPIRICAL_DENSITY Probability density estimation for given data (experimental).
%
% Example:
%   xn=randn(10000,1);
%   [x,p]=empirical_density( xn, 20, 100 );
%   plot( x, p, x, exp(-x.^2/2)/sqrt(2*pi) ); % should match approx.
%
% See also KERNEL_DENSITY, HIST

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


%TODO: still experimental

options=varargin2options( varargin{:} );
[coarse_interp,options]=get_option( options, 'coarse_interp_method', 'pchip' );
[fine_interp,options]=get_option( options, 'fine_interp_method', 'spline' );
check_unsupported_options( options, mfilename );

xl=sort(xl(:));
yl=linspace(0,1,size(xl,1))';

xl2 = linspace(min(xl),max(xl),n1);
yl2 = interp1(xl,yl,xl2,coarse_interp);

pp = interp1(xl2,yl2,fine_interp,'pp');

x = linspace(min(xl2),max(xl2),n);
pp.coefs=vector_polyder( pp.coefs );
p = ppval(pp,x);

if nargout<1
    plot(x,p,varargin{:})
end

function dpp=vector_polyder( pp )
% VECTOR_POLYDER Computes the derivatives of a hole vector of polynomials.
% Note: polynomials have to be row vectors. The first column is not
% removed (do that yourself, if you want to).
% TODO: move into a separate function, higher derivs, integrate, col remove
n=size(pp,2);
M=spdiags((n:-1:1)',1,n,n);
dpp=pp*M;
