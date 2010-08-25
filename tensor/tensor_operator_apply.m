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
[residual,options]=get_option(options,'residual', false );
[reverse,options]=get_option(options,'reverse', residual );
[b,options]=get_option(options,'b', {} );
check_unsupported_options( options, mfilename );

check_tensor_operator_format( A );

da=tensor_operator_size( A, false );
dt=gvector_size( T );
if any(da(:,2)~=dt(:)) && ~(isvector(T) && prod(dt)==prod(da(:,2)))
    error( 'tensor:tensor_operator_apply:mismatch', 'tensor operator and gvector dimension mismatch' );
end


R=size(A,1);
orth_columns=0;
for i=1:R
    if ~reverse
        V=tensor_operator_apply_elementary( A(i,:), T );
    else
        V=tensor_operator_apply_elementary( A(R-i+1,:), T );
    end
    
    if i==1
        if ~residual
            Y=gvector_null(V);
        else
            Y=b;
        end
    elseif is_tensor(Y)
        orth_columns=tensor_rank(Y);
    end
        
    if ~residual
        Y=gvector_add( Y, V );
    else
        Y=gvector_add( Y, V, -1 );
    end
    
    Y1=funcall( truncate_func, Y, 'orth_columns', orth_columns );
    Y2=funcall( truncate_func, Y, 'orth_columns', 0 );
    if is_tensor(Y) && tensor_rank(Y1)~=tensor_rank(Y2)
        keyboard
    end
    Y=Y1;
end

