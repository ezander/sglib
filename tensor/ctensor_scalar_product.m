function d=ctensor_scalar_product( T1, T2, G, varargin )
% CTENSOR_SCALAR_PRODUCT Compute the scalar product of two sparse tensors.
%   D=CTENSOR_SCALAR_PRODUCT( T1, T2 ) computes the scalar product of the
%   two sparse tensors T1 and T2. In the form D=CTENSOR_SCALAR_PRODUCT( T1,
%   T2, G ) the scalar product is taken with respect to the "mass"
%   matrices or Gramians in G (i.e. G{1} and G{2} for order 2 tensors).
%
% Example (<a href="matlab:run_example ctensor_scalar_product">run</a>)
%
% See also CTENSOR_NORM

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3
    G=[];
end
options=varargin2options(varargin);
[orth,options]=get_option(options,'orth',true);
check_unsupported_options(options,mfilename);

check_tensors_compatible( T1, T2 );
if orth && isempty(G)
    d=compute_inner2( T1, T2, G );
else
    d=compute_inner1( T1, T2, G );
end

function d=compute_inner2( T1, T2, G )
% Computes inner product between tensors with high accuracy
for i=1:ctensor_order(T1)
    if isempty(G) || isempty(G{i})
        Q=orth( [T1{i}, T2{i}] );
    else
        error( 'this does not work that way, anybody with a good idea please stand forth' );
        %Q=gram_schmidt( [T1{i}, T2{i}], G{i} );
    end
    T1{i}=Q'*T1{i};
    T2{i}=Q'*T2{i};
end
t1=ctensor_to_vector( T1 );
t2=ctensor_to_vector( T2 );
d=t1'*t2;


function d=compute_inner1( T1, T2, G )
% Computes inner product between tensors with not quite so high accuracy
S=ones(ctensor_rank(T1),ctensor_rank(T2));
for i=1:length(T1)
    if isempty(G)
        S=S.*inner(T1{i},T2{i},[]);
    else
        S=S.*inner(T1{i},T2{i},G{i});
    end
end
d=sum(S(:));


function S=inner( A, B, G )
if ~isempty(G)
    S=A'*G*B;
else
    S=A'*B;
end
