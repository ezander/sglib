function Y=tensor_operator_apply( A, X, varargin )
% TENSOR_OPERATOR_APPLY Apply a tensor operator to a tensor.
%   Y=TENSOR_OPERATOR_APPLY( A, X, VARARGIN ) applies the tensor operator A
%   to the tensor X. Different format for X are supported:
%      vect:     X is an N1N2 vector
%      mat:      X is an N1*N2 matrix
%      tensor:   X is a KxD cell array of vectors of size N and M
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

if isnumeric(X) && isvector(X)
    Y=apply_tensor_vect( A, X );
elseif isnumeric(X) && ~isvector(X)
    Y=apply_tensor_mat( A, X );
elseif iscell(X) || isobject(X)
    Y=apply_tensor_tensor( A, X, truncate_func );
else
    error( 'apply_tensor_operator:vector_type', 'cannot determine vector type (%s)', class(A) );
end


function Y=apply_tensor_tensor( A, X, truncate_func )
if iscell(X)
    d=size(A,2);
    for i=1:d
        check_condition( {A{1,i},X{i}}, 'match', true, {'A{1,i}','X{i}'}, mfilename );
    end
end
R=size(A,1);
for i=1:R
    V=tensor_operator_apply_elementary( A(i,:), X );
    if i==1
        Y=V;
    else
        Y=gvector_add( Y, V );
    end
    Y=funcall( truncate_func, Y );
end


function Y=apply_tensor_mat( A, X )
% TODO: no reduction yet
check_second_order(A);
check_condition( {A{1,1},X}, 'match', false, {'A{1,1}','X'}, mfilename );
check_condition( {A{1,2},X'}, 'match', false, {'A{1,2}','X'''}, mfilename );

K=size(A,1);
for i=1:K
    U=operator_apply(A{i,1},X)';
    V=operator_apply(A{i,2},U)';
    if i==1; 
        Y=V; 
    else
        Y=Y+V; 
    end;
end


function Y=apply_tensor_vect( A, X )
check_second_order(A);
[M1,N1]=operator_size(A{1,1});
[M2,N2]=operator_size(A{1,2});
X=reshape( X, [N1, N2] );
Y=apply_tensor_mat( A, X );
Y=reshape( Y, [M1*M2,1] );


function check_second_order(A)
if size(A,2)>2
    error('tensor:tensor_operator_apply:only_second_order', 'Method only implemented for tensor operators of second order.' );
end
