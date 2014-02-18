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
[b,options]=get_option(options,'b', {} );
[residual,options]=get_option(options,'residual', ~isempty(b) );
[reverse,options]=get_option(options,'reverse', ~residual );
[fast_qr,options]=get_option(options,'fast_qr', false );
check_unsupported_options( options, mfilename );

check_tensor_operator_format( A );

da=tensor_operator_size( A, false );
dt=tensor_size( T );
if ~(isvector(T) && prod(dt)==prod(da(:,2))) && any(da(:,2)~=dt(:) & da(:,2)~=0)
    error( 'tensor:tensor_operator_apply:mismatch', 'Dimensions of the tensor and the tensor operator do not match' );
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
            Y=tensor_null(V);
        else
            Y=b;
        end
    elseif is_ctensor(Y)
        if fast_qr
            orth_columns=ctensor_rank(Y);
        end
    end
        
    if ~residual
        Y=tensor_add( Y, V );
    else
        Y=tensor_add( Y, V, -1 );
    end
    
    Y=funcall( truncate_func, Y, 'orth_columns', orth_columns );
end

