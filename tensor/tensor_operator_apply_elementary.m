function U=tensor_operator_apply_elementary( A, T )
% TENSOR_OPERATOR_APPLY_ELEMENTARY Apply a tensor operator to a sparse tensor product.
%   U=TENSOR_OPERATOR_APPLY_ELEMENTARY( A, T ) applies the tensor product
%   operator A={A1,A2} (mathematically A_1\otimes A_2) to the sparse tensor
%   product T={T1,T2}. The operators in A, i.e. A{1} and A{2}, may be given
%   as matrices or as functions, independently of each other. Each operator
%   that is given as a function must accept an array of vectors to work
%   with (if your function doesn't you'll have to write a wrapper for
%   this).
%
% Example (<a href="matlab:run_example tensor_operator_apply_elementary">run</a>)
%   T={rand(8,3), rand(10,3)}
%   A={rand(8,8), rand(10,10)}
%   B={@(x)(A{1}*x), @(x)(A{2}*x)}
%   C={A{1}, @(x)(A{2}*x)}
%   UA=tensor_operator_apply_elementary(A,T);
%   UB=tensor_operator_apply_elementary(B,T);
%   UC=tensor_operator_apply_elementary(C,T);
%   tensor_norm( tensor_add( UA, UB, -1 ) ) % should be zero
%   tensor_norm( tensor_add( UA, UC, -1 ) ) % should be zero
%
% See also TENSOR_SOLVE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_tensor_operator_format( A );

if isnumeric(T) 
    if isvector(T)
        U=apply_to_vector( A, T );
    else
        U=apply_to_array( A, T );
    end
elseif iscell(T)
    U=apply_to_tensor( A, T );
elseif isobject(T)
    U=tt_tensor_operator_apply_elementary( A, T );
else
    error('unknown tensor type');
end

function U=apply_to_tensor( A, T )
U=cellfun( @operator_apply, A, T, 'UniformOutput', false );

function U=apply_to_vector( A, T )
d=tensor_operator_size( A );
T=reshape( T, d(:,2)' );
U=apply_to_array( A, T );
U=reshape( U, [], 1 );

function U=apply_to_array( A, T )
n=length(A);
d=tensor_operator_size( A );
U=T;
for i=1:n
    U=reshape( U, d(1,2), [] );
    U=A{i}*U;
    d(1,2)=d(1,1);
    d=[d(2:n,:); d(1,:)];
    U=reshape(U,d(:,2)');
    U=permute( U, [2:n, 1] );
end


% if isnumeric(T) && isvector(T)
%     Y=apply_tensor_vect( A, T );
% elseif isnumeric(T) && ~isvector(T)
%     Y=apply_tensor_mat( A, T );
% elseif iscell(T) || isobject(T)
%     Y=apply_tensor_tensor( A, T, truncate_func );
% else
%     error( 'apply_tensor_operator:vector_type', 'cannot determine vector type (%s)', class(A) );
% end
% 
% 
% function Y=apply_tensor_tensor( A, T, truncate_func )
% if iscell(T)
%     d=size(A,2);
%     for i=1:d
%         check_condition( {A{1,i},T{i}}, 'match', true, {'A{1,i}','T{i}'}, mfilename );
%     end
% end
% R=size(A,1);
% for i=1:R
%     V=tensor_operator_apply_elementary( A(i,:), T );
%     if i==1
%         Y=V;
%     else
%         Y=gvector_add( Y, V );
%     end
%     Y=funcall( truncate_func, Y );
% end
% 
% 
% function Y=apply_tensor_mat( A, T )
% % TODO: no reduction yet
% check_second_order(A);
% check_condition( {A{1,1},T}, 'match', false, {'A{1,1}','T'}, mfilename );
% check_condition( {A{1,2},T'}, 'match', false, {'A{1,2}','T'''}, mfilename );
% 
% K=size(A,1);
% for i=1:K
%     U=operator_apply(A{i,1},T)';
%     V=operator_apply(A{i,2},U)';
%     if i==1; 
%         Y=V; 
%     else
%         Y=Y+V; 
%     end;
% end
% 
% 
% 