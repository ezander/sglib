function phi = van_der_corput(n, p, varargin)
% VAN_DER_CORPUT Compute the van der Corput sequence.
%   Q = VAN_DER_CORPUT(N, P, OPTIONS) Computes the values of the van der Corput
%   sequence for base P. P is often chosen as a prime number but doesn't
%   have to be. N is not the length of the produced sequence but must
%   contain the elements for which the van der Corput sequence is computed.
%   If the first M elements of the sequence shall be computed, 1:M can be
%   passed as parameter N.
%
% Options:
%   scamble_func: default [], can be used to pass a function handle or array 
%                 that specifies a permutations of the digits for scrambled 
%                 Halton sequences 
%
% Example (<a href="matlab:run_example van_der_corput">run</a>)
%   van_der_corput(1:10, 2)
%   van_der_corput(1:10, 3)
%   van_der_corput(1:10, 3, "scramble_func", [0, 2, 1])
%
% See also HALTON, HAMMERSLEY, RAND

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


options = varargin2options(varargin);
[scramble_func, options] = get_option(options, 'scramble_func', []);
check_unsupported_options(options, mfilename);

% check that all input values are non-negative integers
check_boolean(all(n(:)>=0), 'n must be positive');
check_boolean(all(n(:)==round(n(:))), 'n must be an integer vector');

phi = zeros(size(n));
q = 1/p;
j = 1;
while true
    % get next base p digit from n and shift n by one digit
    d = rem(n, p);
    n = floor(n / p);
    
    % if needed scramble the digit, and add it in reverse order
    % i.e. compute the (scrambled) radical inverse function
    if ~isempty(scramble_func)
        if isfloat(scramble_func)
            %assert(isequal(sort(scramble_func(:)),(0:p-1)'))
            d = scramble_func(d+1);
        else
            d = funcall(scramble_func, d, p, j);
        end
        d = reshape(d, size(phi));
    end
    phi = phi + q * d;

    % if all n's are zero exit
    if all(n(:)==0)
        break;
    end
    
    % compute new multiplication factor and iteration index
    q = q / p;
    j = j + 1;
end

