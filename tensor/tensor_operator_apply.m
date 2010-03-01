function Y=tensor_operator_apply( A, T, varargin )
% TENSOR_OPERATOR_APPLY Apply a tensor operator to a tensor.
%   Y=TENSOR_OPERATOR_APPLY( A, T, VARARGIN ) applies the tensor operator A
%   to the tensor T. Different format for T are supported:
%      vect:     T is an N1N2 vector
%      mat:      T is an N1*N2 matrix
%      tensor:   T is a KxD cell array of vectors of size N and M
%
% Note: Never use the normal Kronecker product for the tensor operator (in
%   case you want to have an explicit matrix representation). Use the
%   reversed Kronecker product (REVKRON) instead.
%
% Example (<a href="matlab:run_example apply_tensor_operator">run</a>)
%
% See also REVKRON, APPLY_OPERATOR, ISFUNCTION

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[truncate_func, options]=get_option( options, 'truncate_func', @identity );
check_unsupported_options( options, mfilename );

check_tensor_operator_format( A );

da=tensor_operator_size( A, false );
dt=gvector_size( T );
if any(da(:,2)~=dt(:)) && ~(isvector(T) && prod(dt)==prod(da(:,2)))
    error( 'tensor:tensor_operator_apply:mismatch', 'tensor operator and gvector dimension mismatch' );
end

R=size(A,1);
for i=1:R
    V=tensor_operator_apply_elementary( A(i,:), T );
    if i==1
        Y=V;
    else
        Y=gvector_add( Y, V );
    end
    Y=funcall( truncate_func, Y );
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
% function Y=apply_tensor_vect( A, T )
% check_second_order(A);
% [M1,N1]=operator_size(A{1,1});
% [M2,N2]=operator_size(A{1,2});
% T=reshape( T, [N1, N2] );
% Y=apply_tensor_mat( A, T );
% Y=reshape( Y, [M1*M2,1] );
% 
% 
% function check_second_order(A)
% if size(A,2)>2
%     error('tensor:tensor_operator_apply:only_second_order', 'Method only implemented for tensor operators of second order.' );
% end
