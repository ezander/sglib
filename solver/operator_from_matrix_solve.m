function A=operator_from_matrix_solve( M, solver_type, varargin )
% OPERATOR_FROM_MATRIX_SOLVE Creates  a linear operator structure from a matrix.
%   ???? A=OPERATOR_FROM_MATRIX_SOLVE( M ) constructs a linear operator, i.e. a cell array
%   containing information about its size and application to a vector and
%   inversion of a vector, from the matrix M. The first element of A
%   contains the size (domain and codomain of the operator) as a 1x2 array
%   (i.e. [M,N], the second element contains application of the linear
%   operator to a vector from of size [N,K] producing a vector of size
%   [M,K].
%   A=OPERATOR( M, TRUE ) constructs a linear operator, i.e. always
%   solves with the given matrix when applied. See also the option
%   'use_lu'.
%
% Options:
%   use_lu: true, {false}
%     Computes the LU decomposition and stores the result at the end
%     of the cell array acceleration future calls to OPERATOR_APPLY.
%     Has only effect, when SOLVE is set to true.
%
%
% Example (<a href="matlab:run_example operator_from_matrix_solve">run</a>)
%     M=[1, 2, 3; 3, 4, 6; 5, 10, 8];
%     solver=operator_from_matrix_solve(M);
%     [m,n]=operator_size( apply );
%
%     x=ones(n,1);
%     y=A*x;
%     x2=operator_apply( solver, y );
%     disp(round([x,x2, y]));
%
% See also OPERATOR_APPLY, OPERATOR_SIZE, OPERATOR_SOLVE, ISFUNCTION

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
[apply,options]=get_option( options, 'apply', false );
check_unsupported_options( options, mfilename );

if nargin<2
    solver_type='';
end


switch solver_type
    case ''
        % solve each time
        A=operator_from_function( {@msolve, {M,apply}, {1,2}}, size(M') );
    case 'lu'
        % precompute lu decomposition and solve only triangular systems
        [L,U,P]=lu(M);
        [p,j]=find(P'); %#ok
        A=operator_from_function( {@lu_solve, {L,U,p,apply}, {1,2,3,4}}, size(M') );
        p
    case 'chol'
        % precompute choleski decomposition and solve only triangular systems
        L=chol(M,'lower');
        p=1:size(L,1); %#ok
        A=operator_from_function( {@lu_solve, {L,L',p,apply}, {1,2,3,4}}, size(M') );
    case 'ilu'
        % precompute lu decomposition and solve only triangular systems
        %setup.type='nofill';
        %setup.type='ilutp';
        setup.droptol=1e-1;
        setup.milu='off';
        setup.udiag=0;
        setup.thresh=1;
        [L,U,P]=ilu(M,setup); % note: ilu is preferred over luinc
        [p,j]=find(P'); %#ok
        A=operator_from_function( {@lu_solve, {L,U,p,apply}, {1,2,3,4}}, size(M') );
end

multiplot_init(2,1);
multiplot; spy(M);
multiplot; spy(L);

function x=msolve( M, apply, y, varargin )
if apply
    x=M*x;
else
    x=M\y;
end

function x=lu_solve( L, U, p, apply, y, varargin )
if apply
    x(p,:)=L*(U*y);
else
    if issparse(L) || issparse(U)
        x=mldivide(U, mldivide(L,y(p,:)) );
    else
        lower.LT=true;
        upper.UT=true;
        x=linsolve(U, linsolve(L,y(p,:),lower), upper );
    end
end