function [U,S,V]=svd_type_set( U, S, V, type )
% SVD_TYPE_SET Set the SVD type.
%   [U,S,V]=SVD_TYPE_SET(U, S, V, TYPE) changes the SVD to the form
%   specified by TYPE. Suppose the given SVD is a decomposition of the
%   matrix A, then
%   * [U,S,V]=SVD_TYPE_SET(U, S, V, 'matrix') returns matrices U, S and V
%     such that A=U*S*V'.
%   * [U,S,V]=SVD_TYPE_SET(U, S, V, 'matrix') returns matrices U and V and
%     a vector S such that A=U*diag(S)*V'.
%   * [U,S,V]=SVD_TYPE_SET(U, S, V, 'empty') returns matrices U, S and V
%     such that A=U*V' and S is empty.
%
% Note: The SVD must be an "economy size" decomposition, that can be
%   computed by SVD(A,0) or SVD(A,'econ'), such that S is a quadratic
%   matrix and/or U and V' have the same inner dimensions.
%
% Example (<a href="matlab:run_example svd_type_Set">run</a>)
%   A = rand(13, 10);
%   [U,S,V] = svd(A, 0); disp(norm(U*S*V'-A));
%   [U,S,V] = svd_type_set(U,S,V,'vector'); disp(norm(U*diag(S)*V'-A)); 
%   [U,S,V] = svd_type_set(U,S,V,'empty'); disp(norm(U*V'-A)); 
%   [U,S,V] = svd_type_set(U,S,V,'matrix'); disp(norm(U*S*V'-A)); 
%
% See also SVD, SVD_ADD, SVD_UPDATE, SVD_TYPE_GET

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

oldtype = svd_type_get(S);
if strcmp(oldtype, type)
    % nothing to do here.
    return;
end

switch [oldtype, '->', type]
    case 'vector->empty'
        U=U*diag(S);
        S=[];
    case 'matrix->empty'
        U=U*S;
        S=[];
    case 'empty->vector'
        S=sqrt(sum(U.^2,1));
        U=binfun(@times, U, 1./S);
    case 'matrix->vector'
        S=diag(S);
    case 'empty->matrix'
        S=sqrt(sum(U.^2,1));
        U=binfun(@times, U, 1./S);
        S=diag(S);
    case 'vector->matrix'
        S=diag(S);
end
