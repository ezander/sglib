function A=linear_operator( M, solve, varargin )
% LINEAR_OPERATOR Creates  a linear operator structure from a matrix.
%   A=LINEAR_OPERATOR( M ) constructs a linear operator, i.e. a cell array
%   containing information about its size and application to a vector and
%   inversion of a vector, from the matrix M. The first element of A
%   contains the size (domain and codomain of the operator) as a 1x2 array
%   (i.e. [M,N], the second element contains application of the linear
%   operator to a vector from of size [N,K] producing a vector of size
%   [M,K]. 
%   A=LINEAR_OPERATOR( M, TRUE ) constructs a linear operator, i.e. always
%   solves with the given matrix when applied. See also the option
%   'use_lu'.
%
% Options:
%   use_lu: true, {false}
%     Computes the LU decomposition and stores the result at the end
%     of the cell array acceleration future calls to LINEAR_OPERATOR_APPLY.
%     Has only effect, when SOLVE is set to true.
%
%
% Example (<a href="matlab:run_example linear_operator_from_matrix">run</a>)
%     apply=linear_operator_from_matrix([1, 2, 3; 3, 4, 6; 5, 10, 8]);
%     solve=linear_operator_from_matrix([1, 2, 3; 3, 4, 6; 5, 10, 8], true, 'use_lu', true);
%     [m,n]=linear_operator_size( apply );
%
%     x=ones(n,1);
%     y=linear_operator_apply( apply, x );
%     x2=linear_operator_apply( solve, y );
%     disp(round([x,x2, y]));
%
% See also LINEAR_OPERATOR_APPLY, LINEAR_OPERATOR_SIZE, LINEAR_OPERATOR_SOLVE, ISFUNCTION

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
[use_lu,options]=get_option( options, 'use_lu', false );
check_unsupported_options( options, mfilename );

if nargin<2
    solve=false;
end

if ~solve
    A={ size(M), {@mtimes, {M}, {1}} };
elseif ~use_lu
    % solve each time 
    A={ size(M), {@mldivide, {M}, {1}} };
else
    % precompute lu decomposition and solve only triangular systems
    [L,U,P]=lu(M);
    [p,j]=find(P'); %#ok
    A={ size(M), {@lu_solve, {L,U,p}} };
end

function x=lu_solve( b, L, U, p )
lower.LT=true;
upper.UT=true;
x=linsolve(U, linsolve(L,b(p),lower), upper );
