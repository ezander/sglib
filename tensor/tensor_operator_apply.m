function Y=tensor_operator_apply( A, X, varargin )
% TENSOR_OPERATOR_APPLY Apply a tensor operator to a tensor.
%   Y=TENSOR_OPERATOR_APPLY( A, X, VARARGIN ) applies the tensor operator A
%   to the tensor X. Different format for A and X are supported, and can be
%   specified via additional options or automatically detected. The
%   following formats are currently possible for the operator A:
%      revkron:    A is just a huge M1M2xN1N2 matrix
%                i.e. A=revkron(M1xN1,M2xN2))
%      block:    A is an M1xN1 cell array of M2xN2 matrices/linear operators
%      tensor:   A is an Kx2 cell array of M1xN1 and M2xN2 matrices
%   The following vector formats are supported:
%      vect:     X is an N1N2 vector
%      mat:      X is an N1*N2 matrix
%      tensor:   X is a Kx2 cell array of vectors of size N and M
%   Note: the block format has to be specified explicitly, since it cannot
%   be unambiguously differentiated from the tensor format.
%
%   The following combinations of formats are possible:
%      revkron/vect, block/vect, block/mat, tensor/mat, tensor/tensor
%
% Note: Never use the normal Kronecker product for the tensor operator (in
%   case you want to have an explicit matrix representation). Use the
%   reversed Kronecker product (REVKRON) instead.
%
% Example (<a href="matlab:run_example apply_tensor_operator">run</a>)
%
% See also REVKRON, APPLY_LINEAR_OPERATOR, ISFUNCTION

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
[optype,options]=get_option( options, 'optype', 'auto' );
[vectype,options]=get_option( options, 'vectype', 'auto' );
check_unsupported_options( options, mfilename );

if strcmp( optype, 'auto' )
    if isnumeric(A)
        optype='revkron';
    elseif iscell(A)
        optype='tensor';
    else
        error( 'apply_tensor_operator:auto', 'cannot determine tensor operator type (%s)', class(A) );
    end
end


if strcmp( vectype, 'auto' )
    if isnumeric(X) && isvector(X)
        vectype='vect';
    elseif isnumeric(X) && ~isvector(X)
        vectype='mat';
    elseif iscell(X)
        vectype='tensor';
    else
        error( 'apply_tensor_operator:auto', 'cannot determine tensor operator type (%s)', class(A) );
    end
end


switch [optype, '/', vectype]
    case 'revkron/vect'
        Y=apply_revkron_vect( A, X );
    case 'revkron/mat'
        Y=apply_revkron_mat( A, X );
    case 'block/vect'
        Y=apply_block_vect( A, X );
    case 'block/mat'
        Y=apply_block_mat( A, X );
    case 'tensor/tensor'
        Y=apply_tensor_tensor( A, X );
    case 'tensor/mat'
        Y=apply_tensor_mat( A, X );
    case 'tensor/vect'
        Y=apply_tensor_vect( A, X );
    otherwise
        error( 'apply_tensor_operator:format', 'unsupported tensor operator/vector combination: %s',  [optype, '/', vectype]);
end


function Y=apply_revkron_vect( A, X )
%[s1,s2]=linear_operator_size( A );
%[s1,s2]=size( A );
s2=size(X,1);
if s2~=size(X,1)
    check_condition( {A,X}, 'match', false, {'A','X'}, mfilename );
end
Y=linear_operator_apply( A, X );

function Y=apply_revkron_mat( A, X )
Y=linear_operator_apply( A, X(:) );
% TODO: doesn't (and cannot without some additional information) work with
% non square operators A, some sensible error detection needed
Y=reshape(Y,size(X));


function Y=apply_block_vect( A, X )
% TODO: doesn't yet work with general linear operators
[M1,N1]=size(A); %#ok
[M2,N2]=size(A{1,1});  %#ok
Y=cell2mat(A)*X;

function Y=apply_block_mat( A, X )
% TODO: doesn't yet work with general linear operators
[M1,N1]=size(A);  %#ok
[M2,N2]=size(A{1,1});  %#ok
Y=reshape(cell2mat(A)*X(:),[M2,M1]);

function Y=apply_tensor_tensor( A, X )
% TODO: doesn't yet work with higher order tensors
% TODO: no reduction yet
check_condition( {A{1,1},X{1}}, 'match', true, {'A{1,1}','X{1}'}, mfilename );
check_condition( {A{1,2},X{2}}, 'match', true, {'A{1,2}','X{2}'}, mfilename );
[M1,N1]=linear_operator_size(A{1,1}); %#ok
[M2,N2]=linear_operator_size(A{1,2}); %#ok
Y={zeros(M1,0),zeros(M2,0)};
R=size(A,1);
for i=1:R
    Y1n=linear_operator_apply(A{i,1},X{1});
    Y2n=linear_operator_apply(A{i,2},X{2});
    Y={[Y{1}, Y1n], [Y{2}, Y2n] };
end


function Y=apply_tensor_mat( A, X )
% TODO: doesn't yet work with higher order tensors
% TODO: no reduction yet
check_condition( {A{1,1},X}, 'match', false, {'A{1,1}','X'}, mfilename );
check_condition( {A{1,2},X'}, 'match', false, {'A{1,2}','X'''}, mfilename );

K=size(A,1);
for i=1:K
    U=linear_operator_apply(A{i,1},X)';
    V=linear_operator_apply(A{i,2},U)';
    if i==1; Y=V; else Y=Y+V; end;
end


function Y=apply_tensor_vect( A, X )
[M1,N1]=linear_operator_size(A{1,1});
[M2,N2]=linear_operator_size(A{1,2});
X=reshape( X, [N1, N2] );
Y=apply_tensor_mat( A, X );
Y=reshape( Y, [M1*M2,1] );
