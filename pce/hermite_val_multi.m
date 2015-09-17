function y=hermite_val_multi( pce_coeff, pce_ind, x )
% HERMITE_VAL_MULTI Evaluate expansion in multivariate Hermite polynomials.
%   Y=HERMITE_VAL_MULTI( PCE_COEFF, PCE_IND, X ) evaluates the
%   multidimensionl Hermite polynomial given by the coefficients in
%   PCE_COEFF at the positions given in X. PCE_IND(i,j)
%
% Example (<a href="matlab:run_example hermite_val_multi">run</a>)
%   [pcc,pci]=pce_expand_1d( @exp, 4 );
%   x=linspace(0,10)';
%   y=hermite_val_multi( pcc, pci, x );
%   plot(x,y);
%
% See also HERMITE_VAL

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

y=pce_evaluate( pce_coeff, pce_ind, x' )';
return


% check whether arguments x and pce_ind match
d=size(x,2);
if size(pce_ind,2)~=d
    error( 'random vector and pce index vector don''t match' );
end

% make column vector
p=size(pce_coeff,2);
if false && p==1 && ~isscalar(pce_coeff)
    warning('hermite_val_multi:improper_arguments', 'pce_coeff should be a row vector')
    pce_coeff=reshape( pce_coeff, 1, [] );
    p=size(pce_coeff,2);
end

% check whether arguments pce_coeff and pce_ind match
if size(pce_ind,1)~=p
    error( 'pce coeff and pce index vector don''t match' );
end

% about 50 times faster (in cases) than naive implementation (see below)
m=max(pce_ind(:));
h=hermite(m, true);
hx=zeros( [size(x) m+1] );
for i=0:m
    hx(:,:,i+1)=polyval( h(i+1,:), x );
end
hx2=reshape( hx, size(hx,1), [] );

n=size(x,1);
N=size(pce_coeff,1);
y=zeros(n,N);
for k=1:p
    dy=prod( hx2( :, d*pce_ind(k,:)+(1:d) ), 2 );
    y=y+dy*pce_coeff(:,k)';
end

% % original implementation
% pce_coeff=pce_coeff'; % transposed pce_coeff
% n=size(x,1);
% N=size(pce_coeff,2);
% y=zeros(n,N);
% for k=1:p
%     dy=ones(n,1);
%     for i=1:d
%         h=hermite(pce_ind(k,i));
%         dy=dy.*polyval(h,x(:,i));
%     end
%     y=y+dy*pce_coeff(k,:);
% end
