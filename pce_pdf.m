function [y,x]=pce_pdf( x, X_alpha, I_X, varargin )
% PCE_PDF Short description of pce_pdf.
%   Y=PCE_PDF( X, X_ALPHA, I_X, VARARGIN ) Long description of pce_pdf.
%
% Example (<a href="matlab:run_example pce_pdf">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[N,options]=get_option(options,'N',10000);
[Nout,options]=get_option(options,'Nout',100);
[alg,options]=get_option(options,'alg','kernel');
check_unsupported_options(options,mfilename);

% generate random samples
m=size(I_X,2);
xi=randn(m,N);
x_r=pce_evaluate( X_alpha, I_X, xi );

switch alg
    case 'kernel'
        [bandwidth,y,x]=kde(x_r,Nout);
    otherwise
        [x,y]=empirical_density(x_r,N,Nout);
end

% x_r=sort(x_r);
% y_r=linspace(0,1,N);
% 
% % remove duplicates
% rmind=(abs(x_r(2:end)-x_r(1:end-1))==0);
% x_r(rmind)=[];
% y_r(rmind)=[];
% 
% % now interpolate to coarse mesh
% M=30;
% %x_c=linspace( min(x_r), max(x_r), M );
% %y_c=interp1(x_r, y_r, x_c, 'spline');
% 
% ind=round(linspace(1,length(x_r),M));
% x_c=x_r(ind);
% y_c=y_r(ind);
% 
% 
% 
% % ... and take derivate of coarse mesh interpolation
% pp=interp1(x_c, y_c, 'pchip', 'pp');
% pp=interp1(x_c, y_c, 'spline', 'pp');
% pp.coefs=vector_polyder( pp.coefs );
% 
% % Finally evaluate on output points.
% if isempty(x)
%     x=linspace(min(x_r(:)),max(x_r(:)),Nout);
% end
% y = ppval(pp,x);
% 
% % fix both ends of the distribution
% y(isnan(y))=0;
% y(x<=x_r(1))=0;
% y(x>=x_r(end))=0;
% y(y<0)=0;
% 
% 
% function dpp=vector_polyder( pp )
% % VECTOR_POLYDER Computes the derivatives of a hole vector of polynomials.
% % Note: polynomials have to be row vectors. The first column is not
% % removed (do that yourself, if you want to).
% % TODO: move into a separate function, higher derivs, integrate, col remove
% n=size(pp,2);
% M=spdiags((n:-1:1)',1,n,n);
% dpp=pp*M;
