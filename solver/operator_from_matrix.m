function A=operator_from_matrix( M, solve, varargin )
% OPERATOR Creates  a linear operator structure from a matrix.
%   A=OPERATOR( M ) constructs a linear operator, i.e. a cell array
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
% Example (<a href="matlab:run_example operator_from_matrix">run</a>)
%     apply=operator_from_matrix([1, 2, 3; 3, 4, 6; 5, 10, 8]);
%     solve=operator_from_matrix([1, 2, 3; 3, 4, 6; 5, 10, 8], true, 'use_lu', true);
%     [m,n]=operator_size( apply );
%
%     x=ones(n,1);
%     y=operator_apply( apply, x );
%     x2=operator_apply( solve, y );
%     disp(round([x,x2, y]));
%
% See also OPERATOR_APPLY, OPERATOR_SIZE, OPERATOR_SOLVE, ISFUNCTION

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
[use_lu,options]=get_option( options, 'use_lu', false );
check_unsupported_options( options, mfilename );

if nargin<2
    solve=false;
end

if ~solve
    A=operator_from_function( {@apply, {M}, {1}}, size(M) );
elseif ~use_lu
    % solve each time 
    A=operator_from_function( {@msolve, {M}, {1}}, size(M') );
else
    % precompute lu decomposition and solve only triangular systems
    [L,U,P]=lu(M);
    [p,j]=find(P'); %#ok
    A=operator_from_function( {@lu_solve, {L,U,p}, {1,2,3}}, size(M') );
end

function x=apply( M, y, varargin )
x=M*y;

function x=msolve( M, y, varargin )
x=M\y;

function x=lu_solve( L, U, p, y, varargin )
if issparse(L) || issparse(U)
    x=mldivide(U, mldivide(L,y(p,:)) );
else
    lower.LT=true;
    upper.UT=true;
    x=linsolve(U, linsolve(L,y(p,:),lower), upper );
end
