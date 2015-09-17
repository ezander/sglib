function A=operator_from_function( func, size )
% OPERATOR Creates  a linear operator structure from a function.
%   A linear operator is a cell array containing information about its
%   size and application to a vector and inversion of a vector. The second
%   element must contain the size as a 1x2 array (i.e. [M,N], the first
%   element must contain application of the linear operator to a vector
%   from of size [N,K] producing a vector of size [M,K]. 
%   If the second argument FUNC is 'id' then the resulting operator will be
%   the identity operator. SIZE is changed to be the same in both domain
%   and codomain.
%
% Example (<a href="matlab:run_example operator_from_function">run</a>)
%
%
% See also OPERATOR_APPLY, OPERATOR_SIZE, ISFUNCTION

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

if ischar(func) && strcmp(func,'id')
    % maybe at some time we want to have a fixed identity
    %func=@identity;
    %size=[size(1), size(1)];
    A=[];
    return;
end

A={size, func, 'op_marker'};

%function x=identity( x )
% no body, thats all
