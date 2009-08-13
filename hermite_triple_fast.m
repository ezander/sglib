function c=hermite_triple_fast(i,j,k)
% HERMITE_TRIPLE_FAST Cached computation of the expectation of triple products of Hermite polynomials.
%   C=HERMITE_TRIPLE_FAST(I,J,K) computes the value of <H_i H_j H_k> where
%   the H_ijk are the unnormalized (stochastic) Hermite polynomials and the
%   expectation <.> is over a Gaussian measure i.e. <f(X)>=int_-infty^infty
%   f(x) exp(-x^2/2)/sqrt(2*pi) dx. The result is a tensor of order 3, thus
%   you can pass all arguments I, J and K as arrays of multiindices. If you
%   have just one array, say K and want to get rid of the leading singleton
%   dimensions use SQUEEZE.
%
%   The cache has to be set up by a call to hermite_triple_fast with one
%   argument only HERMITE_TRIPLE_FAST(MAX).
%
% Example (<a href="matlab:run_example hermite_triple_fast">run</a>)
%   c1=hermite_triple_fast(2,3,1);
%   c2=hermite_triple_fast(3,1,4);
%   c3=hermite_triple_fast([2 3],[3 1],[1 4]);
%   disp( sprintf( 'c1=%d, c2=%d, c3=%d=c1*c2=%d', c1, c2, c3, c1*c2 ) );
%
%   I=multiindex(4,3); J=multiindex(4,2);
%   T=hermite_triple_fast( I, I, J );
%   spy(sum(T,3))
%
% See also HERMITE, HERMITE_VAL, HERMITE_TRIPLE_PRODUCT, SQUEEZE

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


%TODO: this file should probably be merged with hermit_triple_product and
%the fastest version selected automatically

persistent triples max_ind;

% Only one argument => do the initialization
if nargin==1
    if isempty(max_ind) || i>max_ind
        max_ind=full(i);
        triples=zeros(max_ind+1,max_ind+1,max_ind+1);
        for i=0:max_ind
            for j=0:i
                % The indexing of the following loop takes into account that
                % the sum i+j+k has to be even and that i,j and k have to
                % fulfill the triangle inequality (not that this optimization
                % would matter in any way...)
                % Note: for gPC the step size should be 1, not 2
                for k=i-j:2:j
                    hijk=hermite_triple_product(i,j,k);
                    triples(i+1,j+1,k+1)=hijk;
                    triples(i+1,k+1,j+1)=hijk;
                    triples(j+1,i+1,k+1)=hijk;
                    triples(j+1,k+1,i+1)=hijk;
                    triples(k+1,i+1,j+1)=hijk;
                    triples(k+1,j+1,i+1)=hijk;
                end
            end
        end
    end
    if nargout>0
        c=triples;
    end
    return
end

% If no output argument is given the current cache is returned. This can
% also be used to check whether the cache is already initialized.
if nargin==0
    c=triples;
    return
end

% Check whether cache is correctly initialized
max_ind_cur=max([i(:); j(:); k(:)]);
if isempty(triples) || max_ind_cur>max_ind
    %warning('hermite_triples_fast:cache', 'Cache has not been set up correctly. Setting up cache...');
    %disp([size(triples),max_ind]);
    hermite_triple_fast( max( max_ind_cur, 15 ) );
end

% The purpose of the next few lines is to construct arrays of linear
% indices to index directly into the triples array without need for loops.
% We therefore create order 4 tensors where the first dimension is the
% order of the multiindex, the second if the length of the multiindex set
% i, the second ... you get it. This is done with repmat and then permute
% to get things in a consistent order. The we can construct the linear
% index using the stride of the array, index into triples, and multiply
% along the first dimension (i.e. over the basis variables). Then reshape
% to remove the singleton dimension. (The other way round, i.e. with the
% prod dimension last, stuff doesn't work in matlab, because singleton
% dimensions are somehow removed to early, causing the ordering of
% dimensions to become messed up)

% this is currently the fastest implementation
% (compared with: not first transposing (10%), first permuting (20%),
% keeping tensor format (30-40%))

ni=size(i,1);
nj=size(j,1);
nk=size(k,1);
nd=size(i,2);
strides=cumprod(size(triples));
ind=1+permute( repmat(i',[1 1 nj nk]), [1 2 3 4]);
ind=ind+strides(1)*permute( repmat(j',[1 1 ni nk]), [1 3 2 4]);
ind=ind+strides(2)*permute( repmat(k',[1 1 ni nj]), [1 3 4 2]);
ind=reshape( ind, nd, [] );
c=prod(triples(ind),1);
c=reshape( c, [ni nj nk]);


if 0
    ni=size(i,1);
    nj=size(j,1);
    nk=size(k,1);
    nd=size(i,2);
    strides=cumprod(size(triples));
    I=permute( repmat(i',[1 1 nj nk]), [1 2 3 4]);
    J=permute( repmat(j',[1 1 ni nk]), [1 3 2 4]);
    K=permute( repmat(k',[1 1 ni nj]), [1 3 4 2]);
    I=reshape( I, nd, [] );
    J=reshape( J, nd, [] );
    K=reshape( K, nd, [] );
    ind=1+I+strides(1)*J+strides(2)*K;
    c=prod(triples(ind),1);
    c=reshape( c, [ni nj nk]);
end

if 0
    % This is the implementation I like most, because it's the most
    % symmetric one and doesn't need any reshaping. However, it's 30 to 40
    % percent slower than the current one (above).
    ni=size(i,1);
    nj=size(j,1);
    nk=size(k,1);
    I=repmat( permute(i,[1 3 4 2] ), [1 nj nk 1] );
    J=repmat( permute(j,[3 1 4 2] ), [ni 1 nk 1] );
    K=repmat( permute(k,[3 4 1 2] ), [ni nj 1 1] );
    strides=cumprod(size(triples));
    ind=1+I+strides(1)*J+strides(2)*K;
    c=prod(triples(ind),4);
end


if 0 % old version (does not work on more than one vector argument)

    % Note: multiindices are row vectors => size(i,2)
    if size(i,1)>1 || size(j,1)>1
        error([ 'hermite_triple_product: not yet implemented for ' ...
            'vectors of multiindices in i or j (only in k). Maybe you want to pass a row vector?' ]);
    end

    % Calculation of scalar index (4x faster then sub2ind)
    if size(k,1)>1
        i=repmat( i, size(k,1), 1 );
        j=repmat( j, size(k,1), 1 );
    end
    ind=(i+1)+j*(max_ind+1)+k*(max_ind+1)^2;
    c=prod( triples( ind ), 2 );
end
