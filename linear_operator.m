function A=linear_operator( M, varargin )
% LINEAR_OPERATOR Creates  a linear operator structure from a matrix.
%   A linear operator is a cell array containing information about its
%   size, application to a vector and inversion of a vector. The first
%   element must contain the size as a 1x2 array (i.e. [M,N], the second
%   element must contain application of the linear operator to a vector
%   from of size [N,K] producing a vector of size [M,K]. The third element,
%   if present, must contain a function that provides solving with this
%   linear operator.
%
% Options:
%   use_lu: true, {false}
%     Computes the LU decomposition and stores the result in the solve part
%     of the cell array acceleration future calls to LINEAR_OPERATOR_SOLVE.
%   
%
% Example (<a href="matlab:run_example linear_operator">run</a>)
%     linop=linear_operator([1, 2, 3; 3, 4, 6; 5, 10, 8]);
%     linop2=linear_operator([1, 2, 3; 3, 4, 6; 5, 10, 8], 'use_lu', true);
%     [m,n]=linear_operator_size( linop );
%
%     x=ones(n,1);
%     y=linear_operator_apply( linop, x ); 
%     x2=linear_operator_solve( linop, y ); 
%     x3=linear_operator_solve( linop2, y ); 
%     disp(round([x,x2,x3]));
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

if ~use_lu
    A={ size(M), {@mtimes, {M}, {1}}, {@mldivide, {M}, {1}} };
else
    [L,U,P]=lu(M);
    [p,j]=find(P'); %#ok
    A={ size(M), {@mtimes, {M}, {1}}, {@lu_solve, {L,U,p}} };
end

function x=lu_solve( b, L, U, p )
lower.LT=true;
upper.UT=true;
x=linsolve(U, linsolve(L,b(p),lower), upper );
