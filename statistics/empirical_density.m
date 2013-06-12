function [x,p]=empirical_density(xl,n,nc,varargin)
% EMPIRICAL_DENSITY Probability density estimation for given data.
%   EMPIRICAL_DENSITY(XL,N,NC,VARARGIN) approximates the PDF underlying the
%   given data in XL. N is the number of output points you want to have
%   (should be some factor more than NC in order for the plot to look
%   smooth, and depend further on the smoothness of the distribution.)
%   NC is the number of points of the mesh, on which smooth interpolation
%   of the approximate CDF is performed. If you have a non-smooth
%   distribution you should choose higher values for NC (see Algorithm).
%
% Algorithm:
%   If XL contains samples of a random
%   distribution X, then plotting uniformly sampled values from [0,1] over
%   the *sorted* samples in XL approximates the CDF of X (just try the following
%   with  your samples: plot(sort(xl),linspace(0,1,length(xl))) ).
%   The CDF can now be interpolated by some (preferably continuously
%   differentiable) interpolation method (coarse mesh interpolation, NC). The
%   piecewise polynomials can be analytically differentiated giving an
%   approximation of the PDF. This can now be evaluated at some specified
%   set of points (N).
%
% Example (<a href="matlab:run_example empirical_density">run</a>)
%   xn=[randn(10000,1), 2*rand(10000,1)-2];
%   x=linspace(-4,4);
%   subplot(2,1,1);
%   empirical_density( xn, 30, 10, 'plot_args', {'-*'} );
%   hold on; plot( x, normal_pdf(x,0,1),'k', x, uniform_pdf(x,-2,0),'k'); hold off;
%   xlabel( 'empirical density plot' );
%   legend( 'normal dist.', 'uniform dist.' );
%   subplot(2,1,2);
%   kernel_density( xn, 30, 0.1, '-*' );
%   hold on; plot( x, normal_pdf(x,0,1),'k', x, uniform_pdf(x,-2,0),'k'); hold off;
%   xlabel( 'kernel density plot' );
%   legend( 'normal dist.', 'uniform dist.' );
%
% See also KERNEL_DENSITY, HIST

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


options=varargin2options( varargin );
[plot_args,options]=get_option( options, 'plot_args', {} );
[mesh_interp,options]=get_option( options, 'mesh_interp_method', 'pchip' );
[poly_interp,options]=get_option( options, 'poly_interp_method', 'spline' );
check_unsupported_options( options, mfilename );


if nargin<2 || isempty(n)
    n=100;
end
if nargin<3 || isempty(nc)
    nc=min(n/3,30);
end;


if ~isvector(xl)
    m=size(xl,2);
    if m>100
        warning('empirical_density:many_rows', 'Very large amount of columns specified; maybe you want to transpose the vector?');
    end
    x=zeros(n,m);
    p=zeros(n,m);
    for i=1:m
        [x(:,i),p(:,i)]=empirical_density( xl(:,i), n, nc, varargin{:} );
    end
else
    % Sort input values and associate values from [0,1],
    xl=sort(xl(:));
    yl=linspace(0,1,size(xl,1))';

    % remove duplicates, giving the CDF in (xl,yl).
    ind=[diff(xl)~=0; true];
    xl=xl(ind);
    yl=yl(ind);

    % Interpolate on mesh,
    xl2 = linspace(min(xl),max(xl),nc);
    yl2 = interp1(xl,yl,xl2,mesh_interp);

    % get polynomial approximation on the mesh,
    state=warning('off', 'MATLAB:interp1:ppGriddedInterpolant');
    pp = interp1(xl2,yl2,poly_interp,'pp');
    warning(state);

    % and determine the derivative (pdf=cdf').
    pp.coefs=vector_polyder( pp.coefs );

    % Finally evaluate on fine mesh.
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
