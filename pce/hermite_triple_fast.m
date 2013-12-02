function M=hermite_triple_fast(I_A, I_B, I_C, varargin)
% HERMITE_TRIPLE_FAST Cached computation of the expectation of triple products of Hermite polynomials.
%   M=HERMITE_TRIPLE_FAST(I_A,J,K) computes the value of <H_i H_j H_k> where
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
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[algorithm,options]=get_option( options, 'algorithm', 'default' );
check_unsupported_options( options, mfilename );


%TODO: this file should probably be merged with hermit_triple_product and
%the fastest version selected automatically

persistent triples max_ind;

% If no output argument is given the current cache is returned. This can
% also be used to check whether the cache is already initialized.
if nargin==0
    M=triples;
    return
end

% Compute maximum index for triples cache 
if nargin>=3
    max_ind_cur=full(max([I_A(:); I_B(:); I_C(:)]));
else
    max_ind_cur=full(I_A);
end
max_ind_cur=max( 15, max_ind_cur );
    
% Initialize cache using some heuristic as which algorithm to use
if nargin==1 || isempty(triples) || max_ind_cur>max_ind
    max_ind=max_ind_cur;
    if (max_ind<=140); % best choice actually depends on computer speed and free memory
        triples=compute_hermite_triples_vectorized(max_ind);
    else
        triples=compute_hermite_triples(max_ind);
    end
end

% bail out if only one argument given
if nargin==1
    M=triples;
    return
end

switch algorithm
    case 'vectorized1'
        M=multiplication_tensor_vectorized1( I_A, I_B, I_C, triples);
    case 'vectorized2'
        M=multiplication_tensor_vectorized2( I_A, I_B, I_C, triples);
    case 'indexed'
        M=multiplication_tensor_indexed( I_A, I_B, I_C, triples);
    case 'sparse'
        M=multiplication_tensor_sparse( I_A, I_B, I_C, triples);
    case 'sparseb'
        M=multiplication_tensor_sparse_blocked( I_A, I_B, I_C, triples);
    case {'blocked1', 'default'}
        M=multiplication_tensor_blocked_1( I_A, I_B, I_C, triples);
    otherwise
        error( 'sglib:hermite_triples_fast:param_error', 'Unknown algorithm: %s', algorithm );
end


function M=multiplication_tensor_sparse_blocked(I_a,I_b,I_c,triples)
bs=2000000;
na=size(I_a,1);
nb=size(I_b,1);
nc=size(I_c,1);
bsc=max(floor(bs/(na*nb)),1);
j1=1;
while j1<=nc
    j2=min(j1+bsc-1,nc);
    I_cb=I_c(j1:j2,:);
    Mi=multiplication_tensor_sparse(I_a,I_b,I_cb,triples);
    if j1==1
        M=Mi;
    else
        M=[M Mi];
    end
    j1=j2+1;
end


function M=multiplication_tensor_sparse(I_a,I_b,I_c,triples)
%one16=int16(1);
one32=int32(1);
one16=int32(1);
na=size(I_a,1);
nb=size(I_b,1);
nc=size(I_c,1);
m=size(I_a,2);
strides=cumprod(size(triples));
nzi=reshape(one32:(na*nb*nc), [], 1);
nza=reshape( permute( repmat((one16:na)',[1 nb nc]), [1 2 3]), [], 1);
nzb=reshape( permute( repmat((one16:nb)',[1 na nc]), [2 1 3]), [], 1);
nzc=reshape( permute( repmat((one16:nc)',[1 na nb]), [2 3 1]), [], 1);
for i=1:m
    ind=1+I_a(nza,i)+strides(1)*I_b(nzb,i)+strides(2)*I_c(nzc,i);
    sel=(triples(ind)~=0);
    nzi=nzi(sel);
    nza=nza(sel);
    nzb=nzb(sel);
    nzc=nzc(sel);
end
for i=1:m
    ind=1+I_a(nza,i)+strides(1)*I_b(nzb,i)+strides(2)*I_c(nzc,i);
    if i==1
        Mi=triples(ind);
    else
        Mi=Mi.*triples(ind);
    end
end
M=sparse(double(nza+na*(nzb-1)),double(nzc),Mi,na*nb,nc);



function M=multiplication_tensor_indexed(I_a,I_b,I_c,triples)
one16=int16(1);
one32=int32(1);
na=size(I_a,1);
nb=size(I_b,1);
nc=size(I_c,1);
m=size(I_a,2);
strides=cumprod(size(triples));
nzi=reshape(one32:(na*nb*nc), [], 1);
nza=reshape( permute( repmat((one16:na)',[1 nb nc]), [1 2 3]), [], 1);
nzb=reshape( permute( repmat((one16:nb)',[1 na nc]), [2 1 3]), [], 1);
nzc=reshape( permute( repmat((one16:nc)',[1 na nb]), [2 3 1]), [], 1);
for i=1:m
    ind=1+I_a(nza,i)+strides(1)*I_b(nzb,i)+strides(2)*I_c(nzc,i);
    Mi=triples(ind);
    if i==1
        M=Mi;
    else
        M(nzi)=M(nzi).*Mi;
    end
    sel=(Mi~=0);
    nzi=nzi(sel);
    nza=nza(sel);
    nzb=nzb(sel);
    nzc=nzc(sel);
end
M=reshape( M, [na nb nc]);


function M=multiplication_tensor_blocked_1(I_a,I_b,I_c,triples)
na=size(I_a,1);
nb=size(I_b,1);
nc=size(I_c,1);
m=size(I_a,2);
strides=cumprod(size(triples));
for i=1:m
    ind=1+permute( repmat(I_a(:,i),[1 nb nc]), [1 2 3]);
    ind=ind+strides(1)*permute( repmat(I_b(:,i),[1 na nc]), [2 1 3]);
    ind=ind+strides(2)*permute( repmat(I_c(:,i),[1 na nb]), [2 3 1]);
    %ind=reshape( ind, m, [] );
    Mi=triples(ind);
    if i==1
        M=Mi;
    else
        M=M.*Mi;
    end
end
M=reshape( M, [na nb nc]);


function M=multiplication_tensor_vectorized1(I_a,I_b,I_c,triples)
% This is the implementation I like most, because it's the most
% symmetric one and doesn't need any reshaping. However, it's 30 to 40
% percent slower than the current one (below).
na=size(I_a,1);
nb=size(I_b,1);
nc=size(I_c,1);
IA=repmat( permute(I_a,[1 3 4 2] ), [1 nb nc 1] );
IB=repmat( permute(I_b,[3 1 4 2] ), [na 1 nc 1] );
IC=repmat( permute(I_c,[3 4 1 2] ), [na nb 1 1] );
strides=cumprod(size(triples));
ind=1+IA+strides(1)*IB+strides(2)*IC;
M=prod(triples(ind),4);

function M=multiplication_tensor_vectorized2(I_a,I_b,I_c,triples)
% this is currently the fastest implementation
% (compared with: not first transposing (10%), first permuting (20%),
% keeping tensor format (30-40%))

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

na=size(I_a,1);
nb=size(I_b,1);
nc=size(I_c,1);
m=size(I_a,2);
strides=cumprod(size(triples));
ind=1+permute( repmat(I_a',[1 1 nb nc]), [1 2 3 4]);
ind=ind+strides(1)*permute( repmat(I_b',[1 1 na nc]), [1 3 2 4]);
ind=ind+strides(2)*permute( repmat(I_c',[1 1 na nb]), [1 3 4 2]);
ind=reshape( ind, m, [] );
M=prod(triples(ind),1);
M=reshape( M, [na nb nc]);


function M=compute_hermite_triples(p)
M=zeros(p+1,p+1,p+1);
for i=0:p
    for j=0:i
        % The indexing of the following loop takes into account that
        % the sum i+j+k has to be even and that i,j and k have to
        % fulfill the triangle inequality (not that this optimization
        % would matter in any way...)
        % Note: for gPC the step size should be 1, not 2
        for k=i-j:2:j
            ind=sub2ind( size(M), 1+[i,i,j,j,k,k], 1+[j,k,i,k,i,j], 1+[k,j,k,i,j,i] );
            M(ind)=hermite_triple_product(i,j,k);
        end
    end
end

function M=compute_hermite_triples_vectorized(p)
[I,J,K]=meshgrid(0:p);
S=I+J+K;
S2=S/2;
ind=mod(S,2)==0 & I<=J+K & J<=K+I & K<=I+J;

M=zeros(size(S));
fac=factorial(0:p);
M(ind)=fac(1+I(ind)).*fac(1+J(ind)).*fac(1+K(ind))./(fac(1+S2(ind)-I(ind)).*fac(1+S2(ind)-J(ind)).*fac(1+S2(ind)-K(ind)));
