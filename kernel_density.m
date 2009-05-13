function [x,p]=kernel_density(xl,n,sig,varargin)
% KERNEL_DENSITY Kernel density estimation for given data.
%   [X,P]=KERNEL_DENSITY(XL,N,SIG,VARARGIN) performs a kernel density
%   estimation of the given data(i.e. an empirical estimation of the
%   underlying probability density function). XL contains the data, N is
%   the number of points at which the density should be estimated, and SIG
%   the parameter of the Gaussian used in density estimation (other kernels
%   aren't supported as yet). N and SIG can be given optionally (pass empty
%   brackets [] if you want to specify options). The default for N is 100,
%   and for SIG it is delta/sqrt(m), where delta is the spread of the data
%   and m the size of the data. The larger SIG is chosen the smoother the
%   estimate but also the fewer actual features of the distribution are
%   visible.
%   If no output arguments are present, the kernel density estimate is
%   plotted. Otherwise the plotting is suppressed. The additional
%   arguments (VARARGIN) are passed directly to the PLOT command, so that
%   e.g. line colors, line styles, marker styles can be specified.
% 
% Note: If XL is a vector it doesn't matter whether it is a row or a column
%   vector. If XL is a matrix each XN(i,:) is treated as an independent
%   sample vector i.e. sample vectors are column vectors.
%   
% Example (<a href="matlab:run_example kernel_density">run</a>)
%   xn=randn(1,10000);
%   [x,p]=kernel_density( xn, 100, 0.2 );
%   plot( x, p, x, exp(-x.^2/2)/sqrt(2*pi) ); % should match approx.
%   pause
%   % or 
%   xn2=[randn(1,10000); rand(1,10000)];
%   kernel_density( xn2, 100, 0.2, 'r' );
%
% See also HIST, PLOT

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


if ~isvector(xl)
    if size(xl,1)>100
        warning('kernel_density:many_cols', 'Very large amount of columns specified; maybe you want to transpose the vector?');
    end
    for i=1:size(xl,1)
        if i==1
            [x,p]=kernel_density( xl(i,:), n, sig, varargin{:} );
        else
            [xn,pn]=kernel_density( xl(i,:), n, sig, varargin{:} );
            xn; %#ok: xn unused
            p=[p pn];
        end
    end
else
    xl=xl(:);
    x1=min(xl);
    x2=max(xl);
    if nargin<3 || isempty(sig)
        sig=(x2-x1)/sqrt(size(xl,1));
    end
    if nargin<2 || isempty(n)
        n=100;
    end

    x1=x1-2*sig;
    x2=x2+2*sig;

    x=repmat(x1,n,1)+(0:n-1)'*(x2-x1)/(n-1);
    p=zeros(n,size(xl,2));
    if 0
        for i=1:size(xl,1)
            p=p+exp(-(repmat(xl(i,:),n,1)-x).^2/sig^2);
        end
    else
        for i=1:n
            p(i,:)=sum( exp( -(xl-x(i,:)).^2/sig^2 ), 1);
        end
    end

    p=p/(size(xl,1)*sqrt(pi)*sig);
end
    
if nargout==0
    plot(x,p,varargin{:});
end

