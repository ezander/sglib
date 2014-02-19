function [Pinv,P,info]=stochastic_preconditioner( A, varargin)
% STOCHASTIC_PRECONDITIONER Create the mean based preconditioner from a stochastic operator.
%   PINV=STOCHASTIC_PRECONDITIONER( A, USE_LU ) creates the mean based
%   preconditioner PINV from the stochastic operator A in that MINV
%   approximates the inverse of A, or rather
%      OPERATOR_APPLY(PINV,OPERATOR_APPLY(A{1,:},X)==X 
%   for any vector or tensor X. If USE_LU the LU decompositions of the
%   matrices are precomputed and result in faster solve times later on.
%   Otherwise application of MINV result in solving with A{1,:} (of course
%   no inversion of the matrices is done here!). 
%
% Example (<a href="matlab:run_example stochastic_preconditioner">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[precond_type,options]=get_option(options,'precond_type',0);
[decomp_type,options]=get_option(options,'decomp_type','lu');
[decomp_options,options]=get_option(options,'decomp_options',{});
[num_iter,options]=get_option(options,'num_iter',3);
check_unsupported_options(options,mfilename);

R=tensor_operator_order( A );
Pinv=cell( 1, R );
P=cell( 1, R );
info=cell( 1, R );

switch precond_type
    case {0, 'mean'} % mean based
        M=A(1,:);
    case {1, 'kron'} % kronecker
        % see van Loan & Pitsianis, Ullmann
        M=A(1,:);
        M=minimise_kron( M, A, 1 );
    case {2, 'vanloan'} % kronecker iterative
        % see van Loan & Pitsianis, Ullmann
        M=A(1,:);
        for i=1:num_iter
            for j=1:R
                M=minimise_kron( M, A, j );
            end
        end
    case {3, 'ikron'} % kronecker this is my own rather complicated one,
        % converges fast but takes LOOONG to construct
        M=A(1,:);
        M=minimise_ikron( M, A );
    case {4, 'two'}
        error('not tested')
        A1=A(1,:);
        A2=A(2,:);
        A1inv=cell( 1, R );
        for i=1:R
            A1inv{i}=operator_from_matrix_solve( A1{i}, decomp_type, 'decomp_options', decomp_options );
        end
        func=@(x)(preconditioner_two_apply(A1inv, A2, x));
        size=operator_size(A1);
        Pinv=operator_from_function(func, size);
    otherwise
        error( 'sglib:stochastic_precond', 'unknown preconditioner type: %d', precond_type );
end

for i=1:R
    if ~isnumeric( M{i} )
        error( 'sglib:preconditioner', 'Elements of stochastic operator must be matrices for this function' );
    end
    [Pinv{i},P{i},info{i}]=operator_from_matrix_solve( M{i}, decomp_type, 'decomp_options', decomp_options );
end

function M=minimise_kron( M, A, j )
a0=frobenius_inner(M{j},M{j});
R=size(A,2);
for i=1:R
    if i==j; continue; end
    M{i}=0*M{i};
end
for k=1:size(A,1)
    ak=frobenius_inner(M{j},A{k,j});
    for i=1:R
        if i==j; continue; end
        M{i}=M{i}+ak/a0*A{k,i};
    end
end


function M=minimise_ikron( M, A )
U=inv(M{1});
V=0*M{2};

H=V;
K=V;
for i=1:size(A,1)
    ai=trace(U*A{i,1});
    K=K+ai*A{i,2}';
    for j=1:size(A,1)
        aij=trace(U'*A{i,1}'*A{j,1}*U);
        H=H+aij*(A{i,2}'*A{j,2});%+A{j,2}'*A{i,2});
    end
end
V=(H'\K')';
%Minv={U,V};
%V=0.5*(V+V'); % TODO: ???
M{2}=inv(V);


function y=preconditioner_two_apply(A1inv, A2, x)
y1=operator_apply(A1inv,x);
z=operator_apply(A2,y1);
y2=operator_apply(A1inv,z);
y=tensor_add(y1, y2, -1);

