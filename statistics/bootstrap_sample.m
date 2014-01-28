function y=bootstrap_sample(x, m, n)
% BOOTSTRAP_SAMPLE Performs bootstrap sampling from the an empiric distribution.
%   Y=BOOTSTRAP_SAMPLE(X, M, N) returns a matrix of size MxN with random
%   samples drawn uniformly with replacement from the values (samples)
%   given in X. 
%   Y=BOOTSTRAP_SAMPLE(X, M) or Y=BOOTSTRAP_SAMPLE(X, M, []) returns a
%   matrix of size MxN, where N will be the same as the number of samples
%   in X (i.e. N=numel(X)).
%
% Example (<a href="matlab:run_example bootstrap_sample">run</a>)
%   % Sample from a set of prime numbers
%   x = [2, 3, 5, 7, 11, 13];
%   bootstrap_sample(x, 3, 5)
%
% See also RANDI

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

imax = numel(x);
if nargin<3 || isempty(n)
    n = imax;
end
ind = randi(imax,m,n);

% The reshape is necessary if N or M is 1 and X is vector of different
% shape
y=reshape(x(ind), m, n);
