function U=tensor_apply( A, T )
% TENSOR_APPLY Apply a tensor operator to a sparse tensor products.
%   U=TENSOR_APPLY( A, T ) applies the tensor product operator A={A1,A2}
%   (mathematically A_1\otimes A_2) to the sparse tensor product T={T1,T2}.
%   The operators in A, i.e. A{1} and A{2}, may be given as matrices or as
%   functions, independently of each other. Each operator that is given as
%   a function must accept an array of vectors to work with (if your
%   function doesn't you'll have to write a wrapper for this).
%
% Example (<a href="matlab:run_example tensor_apply">run</a>)
%   T={rand(8,3), rand(10,3)}
%   A={rand(8,8), rand(10,10)}
%   B={@(x)(A{1}*x), @(x)(A{2}*x)}
%   C={A{1}, @(x)(A{2}*x)}
%   UA=tensor_apply(A,T);
%   UB=tensor_apply(B,T);
%   UC=tensor_apply(C,T);
%   tensor_norm( tensor_add( UA, UB, -1 ) ) % should be zero
%   tensor_norm( tensor_add( UA, UC, -1 ) ) % should be zero
%
% See also TENSOR_SOLVE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


U={ apply(A{1},T{1}), apply(A{2},T{2}) };

function U=apply( A, T )
if isfunction(A)
    U=funcall(A,T);
elseif isnumeric(A)
    U=A*T;
else
    error([ 'unknown type for apply: ', class(A)]);
end
