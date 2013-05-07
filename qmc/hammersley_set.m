function q = hammersley_set(n, d, varargin)
% HAMMERSLEY_SET Generates the Hammersley set.
%   Q=HAMMERSLEY_SET(N, D) generates the Hammersley set of dimension D with
%   N points in each dimension. The returned array Q is an N x D matrix. A
%   D-dimensional Hammersley set is a D-1-dimensional Halton sequence with
%   the last column (i.e. the D-th dimension) being equally spaced values
%   from 1/N, 2/N to N/N.
%   The options for HAMMERSLEY_SET are exactly the same as for
%   HALTON_SEQUENCE.
%
% Example (<a href="matlab:run_example hammersley_set">run</a>)
%   n=200;
%   subplot(2,2,1)
%   x = hammersley_set(n, 5);
%   plot(x(:,1), x(:,2), '.')
%   subplot(2,2,2)
%   x = hammersley_set(n, 5);
%   plot(x(:,1), x(:,3), '.')
%   subplot(2,2,3)
%   x = hammersley_set(n, 5);
%   plot(x(:,1), x(:,5), '.')
%   subplot(2,2,4)
%   x = hammersley_set(n, 5);
%   plot(x(:,3), x(:,4), '.')
%
% References:
%   http://en.wikipedia.org/wiki/Constructions_of_low-discrepancy_sequences#The_Hammersley_set 
%
% See also HALTON_SEQUENCE, VAN_DER_CORPUT

%   Elmar Zander
%   Copyright 2013, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

q = halton_sequence(n, d-1, varargin{:});
q = [q, (1:n)'/n];
