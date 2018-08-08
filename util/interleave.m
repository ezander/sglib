function C=interleave(A, B, dim)
% INTERLEAVE Short description of interleave.
%   INTERLEAVE(VARARGIN) Long description of interleave.
%
% Example (<a href="matlab:run_example interleave">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2017, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if nargin<3
    dim = 1;
end

ndim = ndims(A);
assert(ndim == ndims(B));

A = shiftdim(A, dim-1);
B = shiftdim(B, dim-1);

sz = size(A);
sz(1) = sz(1) + size(B,1);
C = zeros(sz);

C(1:2:end,:) = reshape(A, size(A,1), []);
C(2:2:end,:) = reshape(B, size(B,1), []);

C = shiftdim(C, ndim - dim + 1);
