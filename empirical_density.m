function [x,p]=empirical_density(xl,n,nc,varargin)
% EMPIRICAL_DENSITY Probability density estimation for given data.
%   EMPIRICAL_DENSITY(XL,N,NC,VARARGIN) approximates the PDF underlying the
%   given data in XL. NC is the number of points of the coarse mesh
%   interpolation, N the number of points for the fine mesh (output)
%   interpolation (see Algorithm).
%
% Algorithm:
%   The idea is the following, if xl contains samples of a random
%   distribution X and you sort the values in xl, and plot them over [0,1]
%   the result will approximate the inverse of the cumulative distribution
%   function of X. This can be interpolated on a coarse mesh and then
%   projected onto a finer mesh to give a good approximation of the PDF or
%   the CDF.
%
% Example (<a href="matlab:run_example empirical_density">run</a>)
%   xn=[randn(10000,1), 2*rand(10000,1)-2];
%   subplot(2,1,1);
%   empirical_density( xn, 30, 10, 'plot_args', {'-*'} );
%   xlabel( 'empirical density plot' );
%   legend( 'normal dist.', 'uniform dist.' );
%   subplot(2,1,2);
%   kernel_density( xn, 30, 0.1, '-*' );
%   xlabel( 'kernel density plot' );
%   legend( 'normal dist.', 'uniform dist.' );
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


options=varargin2options( varargin{:} );
[plot_args,options]=get_option( options, 'plot_args', {} );
[coarse_interp,options]=get_option( options, 'coarse_interp_method', 'pchip' );
[fine_interp,options]=get_option( options, 'fine_interp_method', 'spline' );
check_unsupported_options( options, mfilename );


if nargin<2 || isempty(n)
    n=100;
end
if nargin<3 || isempty(nc)
    nc=min(n/3,30);
end;


if ~isvector(xl)
    if size(xl,2)>100
        warning('empirical_density:many_rows', 'Very large amount of rows specified; maybe you want to transpose the vector?');
    end
    x=zeros(n,0);
    p=zeros(n,0);
    for i=1:size(xl,2)
        [xn,pn]=empirical_density( xl(:,i), n, nc, varargin{:} );
        x=[x xn];
        p=[p pn];
    end
else
    % sort input values and associate values from [0,1]
    xl=sort(xl(:));
    yl=linspace(0,1,size(xl,1))';

    % interpolate on coarse mesh
    xl2 = linspace(min(xl),max(xl),nc);
    yl2 = interp1(xl,yl,xl2,coarse_interp);

    % interpolate to fine mesh
    pp = interp1(xl2,yl2,fine_interp,'pp');

    % determine derivative (pdf=cdf')...
    pp.coefs=vector_polyder( pp.coefs );

    % and evaluate
    x = linspace(min(xl2),max(xl2),n)';
    p = ppval(pp,x);
end

if nargout<1
    plot(x, p, plot_args{:});
end


function dpp=vector_polyder( pp )
% VECTOR_POLYDER Computes the derivatives of a hole vector of polynomials.
% Note: polynomials have to be row vectors. The first column is not
% removed (do that yourself, if you want to).
% TODO: move into a separate function, higher derivs, integrate, col remove
n=size(pp,2);
M=spdiags((n:-1:1)',1,n,n);
dpp=pp*M;
