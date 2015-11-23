function M=gpcbasis_triples(V_a, V_b, V_c, varargin)
% GPCBASIS_TRIPLES Computation of the expectation of triple products of GPC polynomials.
%   M=GPCBASIS_TRIPLES(V_A,V_B,V_C) computes the value of 
%    <Psi_alpha Psi_beta Psi_gamma> where
%   the Psi_alpha are the multivariate GPC polynomials and the expectation
%   <.> is over the measure of the random variable corresponding to the
%   system of orthogonal polynomial i.e. The result is a tensor of order 3,
%   thus you can pass all arguments V_A, V_B and V_C as arrays of
%   multiindices.
%
% Example (<a href="matlab:run_example gpcbasis_triples">run</a>)
%   I=multiindex(4,3); J=multiindex(4,2);
%   syschars = 'hhpp';
%   M=gpcbasis_triples( {syschars, I}, {syschars, I}, {syschars, I} );
%   spy(sum(M,3))
%
% See also GPC, GPC_EVALUATE, SQUEEZE

%   Elmar Zander
%   Copyright 2012, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[by_quadrature,options]=get_option( options, 'by_quadrature', false );
check_unsupported_options( options, mfilename );

syschars = V_a{1};
I_a = V_a{2};
I_b = V_b{2};
I_c = V_c{2};

check_boolean(isequal(syschars, V_b{1}), 'polynomial system of A doesn''t match that of B', mfilename);
check_boolean(isequal(syschars, V_b{1}), 'polynomial system of A doesn''t match that of B', mfilename);
check_boolean(size(I_a,2)==size(I_b,2), 'size of germ of A doesn''t match that of B', mfilename);
check_boolean(size(I_a,2)==size(I_c,2), 'size of germ of A doesn''t match that of C', mfilename);

triple_opts = {by_quadrature};
M=multiplication_tensor(syschars, I_a, I_b, I_c, triple_opts);


function M=multiplication_tensor(syschars, I_a, I_b, I_c, triple_opts)

% This is the implementation I like most, because it's the most
% symmetric one and doesn't need any reshaping. However, it's 30 to 40
% percent slower than the current one (below).
p = max([max(I_a(:)), max(I_b(:)), max(I_c(:))]);
m = length(syschars);
na=size(I_a,1);
nb=size(I_b,1);
nc=size(I_c,1);
IA=repmat( permute(I_a,[1 3 4 2] ), [1 nb nc 1] );
IB=repmat( permute(I_b,[3 1 4 2] ), [na 1 nc 1] );
IC=repmat( permute(I_c,[3 4 1 2] ), [na nb 1 1] );
strides=[(p+1), (p+1)^2];
ind=1+IA+(p+1)*IB+strides(2)*IC;
if m==1
    triples=polysys_triples_by_order(syschars, p, triple_opts{:});
    M=prod(triples(ind),4);
else
    M = ones(na, nb, nc);
    for j=1:m
        triples=polysys_triples_by_order(syschars(j), p, triple_opts{:});
        M=M.*triples(ind(:,:,:,j));
    end
end



function M=polysys_triples_by_order(syschar, p, by_quadrature)
[I,J,K]=meshgrid(0:p);
if by_quadrature
    ind=I<=J+K & J<=K+I & K<=I+J;
    M=zeros(size(I));
    M(ind) = polysys_triples_by_quadrature(syschar, p, I(ind), J(ind), K(ind), 1e-10);
    return
end

T=I+J+K;
S=T/2;
switch upper(syschar)
    case {'H', 'P', 'T', 'U', 'M'}
        % symmetrical polynomials
        ind=mod(T,2)==0 & I<=J+K & J<=K+I & K<=I+J;
    case {'L'}
        % asymmetrical polynomials
        ind=I<=J+K & J<=K+I & K<=I+J;
    otherwise
        error('sglib:gpc:polysys', 'Unknown polynomial system char: %s', syschar);
end

M=zeros(size(S));
M(ind) = polysys_triples_by_index(syschar, p, I(ind), J(ind), K(ind), S(ind));


function M = polysys_triples_by_index(syschar, p, I, J, K, S)
switch upper(syschar)
    case 'H'
        % This version is approx. 10% slower than the one, with just one
        % division. However, it avoids overflow up to much large order of
        % the polynomial degree. Note also the cycling of the indices here.
        
        % TODO: better numerical accuracy could be achieved by sorting:
        % e.g. A=sort([I;J;K],1); I=A(1,:),..., then I!/(S-K!) J!/(S-J)!...
        M = (factorial(I) ./ factorial(S-J)) .* ...
            (factorial(J) ./ factorial(S-K)) .* ...
            (factorial(K) ./ factorial(S-I));
    case 'P'
        % see e.g. Thesis of E. Ullmann
        A = [1,  cumprod(1:2:(4*p-1)) ./ cumprod(1:(2*p))]';
        M = 1 ./ (2*S+1) .* ...
            A(S-I+1) .* A(S-J+1) .* A(S-K+1) ./ A(S+1);
    case 'M'
        % the Monomials are pretty trivial
        M = double(I+J==K);
    case {'T', 'U', 'L'}
        % Haven't implemented explicit formulas yet (should be easy for
        % Chebyshev)
        M = polysys_triples_by_quadrature(syschar, p, I, J, K, 1e-10);
        syschar = upper(syschar);
    otherwise
        error('sglib:gpc:polysys', 'Unknown polynomial system char: %s', syschar);
end

if syschar == lower(syschar) % lower case signifies normalised polynomials
    z = 1 ./ sqrt(polysys_sqnorm(upper(syschar), 0:p))';
    M = M .* z(I+1) .* z(J+1) .* z(K+1);
end


function M = polysys_triples_by_quadrature(syschar, p, I, J, K, thresh)
if nargin<6
    thresh = 1e-10;
end

% required number of points, an n point Gauss rule is exact to order
% 2n-1 and we need order 3p
n = ceil((3*p+1)/2);
[x,w] = polysys_int_rule(syschar, n);

% evaluate polynomials at Gauss points and build triple products
y = gpc_evaluate(eye(p+1), {syschar, multiindex(1,p)}, x);
M = (y(I+1,:).*y(J+1,:).*y(K+1,:)) * w;

% remove near zero elements
M(abs(M)<thresh )=0;
