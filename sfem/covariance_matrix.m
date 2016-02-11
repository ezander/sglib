function C=covariance_matrix( pos, covar_func, varargin )
% COVARIANCE_MATRIX Calculate point covariance matrix.
%   C=COVARIANCE_MATRIX( POS, COVAR_FUNC, VARARGIN ) computes the
%   covariance matrix for all combinations of points given in POS using the
%   specified covariance function given in COVAR_FUNC. COVAR_FUNC has to
%   comply to the interface covar_func( x1, x2 ) (see also
%   PARAMETERIZED_FUNCTIONS)
%
%   POS must be DxN where D is the spatial dimension and N is the number of
%   points. C is then a NxN matrix.
%
% Options:
%   max_dist: {inf}
%     If set to a finite value only values of the covariance function of
%     point pairs with Euclidean distance smaller or equal max_dist are
%     computed and the result is returned as a sparse matrix.
%
% Example (<a href="matlab:run_example covariance_matrix">run</a>)
%   x=linspace(0,1,10);
%   C=covariance_matrix( x, {@gaussian_covariance, {0.3, 2}} );
%
% See also GAUSSIAN_COVARIANCE, EXPONENTIAL_COVARIANCE

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
[max_dist,options]=get_option( options, 'max_dist', inf );
check_unsupported_options( options, mfilename );

if isinf(max_dist)
    C=covariance_matrix_complete( pos, covar_func );
else
    C=covariance_matrix_approx( pos, covar_func, max_dist );
end

function C=covariance_matrix_complete( pos, covar_func )
n=size(pos,2);C=zeros(n,n);

for i=1:n
    C(i:end,i)=funcall( covar_func, repmat(pos(:,i),1,n-i+1), ...
        pos(:,i:end) );
    C(i,i:end)=C(i:end,i)';
end


function C=covariance_matrix_approx1( pos, covar_func, max_dist )
n=size(pos,2);
C=sparse(n,n);

for i=1:n
    d=sum((repmat(pos(:,i),1,n-i+1)-pos(:,i:end)).^2,1);
    ind=i-1+find(d<max_dist^2);
    C(ind,i)=funcall( covar_func, repmat(pos(:,i),1,length(ind)), ...
        pos(:,ind) );
    C(i,ind)=C(ind,i)';
end

function C=covariance_matrix_approx2( pos, covar_func, max_dist )
n=size(pos,2);

ind1=[];
ind2=[];
val=[];

for i=1:n
    d=sum((repmat(pos(:,i),1,n-i+1)-pos(:,i:end)).^2,1);
    ind=i-1+find(d<max_dist^2);
    valn=funcall( covar_func, repmat(pos(:,i),1,length(ind)), ...
        pos(:,ind) );
    
    m=length(ind);
    indb=repmat(i,1,m);
    ind1=[ind1, ind, indb(2:end)];
    ind2=[ind2, indb, ind(2:end)];
    val=[val, valn, valn(2:end)];
end

C=sparse( ind1, ind2, val, n, n );


function C=covariance_matrix_approx( pos, covar_func, max_dist )
n=size(pos,2);

alloc=n;
curr=0;
ind1=zeros(1,alloc);
ind2=zeros(1,alloc);
val=zeros(1,alloc);

for i=1:n
    %d=sum((repmat(pos(:,i),1,n-i+1)-pos(:,i:end)).^2,1);
    dx=(repmat(pos(:,i),1,n-i+1)-pos(:,i:end));
    d=sum(dx.*dx,1);
    ind=i-1+find(d<max_dist^2);
     valn=funcall( covar_func, repmat(pos(:,i),1,length(ind)), ...
         pos(:,ind) );
%     p=pos(:,ind)-pos(:,i);
%     valn=funcall( covar_func, p, [] );
    
    m=length(ind);
    while curr+2*m>alloc
        alloc=alloc*2;
        ind1(alloc)=0;
        ind2(alloc)=0;
        val(alloc)=0;
    end
    
    ind1(curr+1:curr+m)=ind;
    ind2(curr+1:curr+m)=i;
    val(curr+1:curr+m)=valn;
    curr=curr+m;

    ind1(curr+1:curr+m-1)=i;
    ind2(curr+1:curr+m-1)=ind(2:end);
    val(curr+1:curr+m-1)=valn(2:end);
    curr=curr+m-1;
end

C=sparse( ind1(1:curr), ind2(1:curr), val(1:curr), n, n );


