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
%   xn=randn(10000,1);
%   [x,p]=kernel_density( xn, 100, 0.2 );
%   plot( x, p, x, exp(-x.^2/2)/sqrt(2*pi) ); % should match approx.
%   %pause
%   % or
%   xn2=[randn(10000,1), 2*rand(10000,1)];
%   kernel_density( xn2, 30, 0.1, '-*' );
%   legend( 'normal dist.', 'uniform dist.' );
%
% See also HIST, PLOT, EMPIRICAL_DENSITY

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


if nargin<2 || isempty(n)
    n=100;
end
if nargin<3;
    sig=[];
end;


if ~isvector(xl)
    m=size(xl,2);
    if m>100
        warning('kernel_density:many_rows', 'Very large amount of rows specified; maybe you want to transpose the vector?');
    end
    x=zeros(n,m);
    p=zeros(n,m);
    for i=1:size(xl,2)
        [x(:,i),p(:,i)]=kernel_density( xl(:,i), n, sig, varargin{:} );
    end
else
    xl=xl(:);
    x1=min(xl);
    x2=max(xl);
    if isempty(sig)
        sig = compute_sig(xl);
    end

    x1=x1-2*sig;
    x2=x2+2*sig;

    x=repmat(x1,n,1)+(0:n-1)'*(x2-x1)/(n-1);
    p=zeros(n,size(xl,2));
    for i=1:n
        p(i,:)=sum( exp( -(xl-x(i,:)).^2/sig^2 ), 1);
    end

    p=p/(size(xl,1)*sqrt(pi)*sig);
end

if nargout==0
    plot_args=varargin;
    plot(x,p,plot_args{:});
end

function sig=compute_sig(xl)
s = std(xl);
N = size(xl,1);
%sig=(x2-x1)/sqrt(n);
% normal distribution approximation, Gaussian approximation, or Silverman's rule of thumb.
% http://sfb649.wiwi.hu-berlin.de/fedc_homepage/xplore/ebooks/html/spm/spmhtmlnode15.html
sig= s * (4/(3*N)) ^ 0.2;

