function Q=sobol_sequence(N, D, varargin)
%   Q=SOBOL_SEQUENCE(N, D, OPTIONS) generates and N x D array of points
%   for quasi Monte Carlo integration. Each of the D columns contains N
%   points of the Sobol sequence.
%
%   The data and algorithm for the Sobol sequence are taken and translated
%   from S. Joe and F. Kuo's website [1]. Additional information on the
%   primitive polynomials and direction numbers used for generating the
%   Sobol sequences can be found in [2] and [3].
%
% Options:
%   'filename': Choose a different file specifying the irreducible
%               polynomials used in the algorithm. Default is
%               'new-joe-kuo-6.21201' from [1].
%   'n0':       Start at index N0 of the sequence instead of 1.
%
% Example (<a href="matlab:run_example sobol_sequence">run</a>)
%   % Generate the plot from Wikipedia:Halton_sequence
%   clf
%   x = sobol_sequence(10, 2);
%   plot(x(:,1), x(:,2), 'ro')
%   hold all;
%   x = sobol_sequence(90, 2, 'n0', 11);
%   plot(x(:,1), x(:,2), 'bo')
%   hold all;
%   x = sobol_sequence(156, 2, 'n0', 101);
%   plot(x(:,1), x(:,2), 'go')
%   axis square
%   hold off;
%
% References:
%   [1] http://web.maths.unsw.edu.au/~fkuo/sobol/index.html
%   [2] S. Joe and F. Y. Kuo, Remark on Algorithm 659: Implementing Sobol's
%       quasirandom sequence generator, ACM Trans. Math. Softw. 29, 49-57 (2003).
%   [3] S. Joe and F. Y. Kuo, Constructing Sobol sequences with better
%       two-dimensional projections, SIAM J. Sci. Comput. 30, 2635-2654 (2008). 
%
% See also HALTON_SEQUENCE, GPC_SAMPLE

%   Elmar Zander
%   Copyright 2016, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin, mfilename);
[filename,options]=get_option(options, 'filename', 'new-joe-kuo-6.21201');
[n0,options]=get_option(options, 'n0', 1);
check_unsupported_options(options);

n1=n0 + N - 1;

%% L = max number of bits needed
L = ceil(log2(n1));

%% C(i) = index from the right of the first zero bit of i-1
C = nan(n1,1);
value = (0:n1-1)';

for i=1:L
    idx = isnan(C) & ~bitand(value, 1);
    C(idx) = i;
    value = bitshift(value, -1);
end

%%
Q = nan(n1,D);

%% Compute the first dimension

% Compute direction numbers V(1) to V(L), scaled by 2^32
V = 2 .^ (32 - (1:L)');

% Evalulate X(1) to X(N), scaled by 2^32
X = zeros(n1,1);
Q(1,1)=0;
for i=2:n1
    X(i) = bitxor( X(i-1), V(C(i-1)) );
    Q(i,1) = X(i) / (2^32);
end


%% Compute the remaining dimensions
fid = fopen(filename, 'r');
fgetl(fid); % skip first line

for j=2:D
    
    % Read in parameters from file
    line=fgetl(fid);
    vals=sscanf(line, '%d');
    d=vals(1);
    s=vals(2);
    a=vals(3);
    m=vals(4:end);
    
    % Compute direction numbers V(1) to V(L), scaled by 2^32
    V = nan(L,1);
    if L<=s
        i = (1:L)';
        V = bitshift(m(1:L), 32-i);
    else
        i = (1:s)';
        V(1:s) = bitshift(m, 32-i);
        for i=s+1:L
            V(i) = bitxor( V(i-s), bitshift(V(i-s), -s));
            for k=1:s-1
                V(i) = bitxor( V(i), bitand(bitshift(a, -(s-1-k)),1)*V(i-k) );
            end
        end
    end
    
    X = zeros(n1,1);
    Q(1,j)=0;
    
    for i=2:n1
        X(i) = bitxor( X(i-1), V(C(i-1)) );
        Q(i,j) = X(i) / (2^32);
    end
end

fclose(fid);
Q = Q(n0:n1, :);
