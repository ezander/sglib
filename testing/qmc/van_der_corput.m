function q = van_der_corput(n, p)
% VAN_DER_CORPUT Compute the van der Corput sequence.
%   Q = VAN_DER_CORPUT(N, P) Computes the values of the van der Corput
%   sequence for base P. P is often chosen as a prime number but doesn't
%   have to be. N is not the length of the produced sequence but must
%   contain the elements for which the van der Corput sequence is computed.
%   If the first M elements of the sequence shall be computed, 1:M can be
%   passed as parameter N.
%
% Example (<a href="matlab:run_example van_der_corput">run</a>)
%   van_der_corput(1:10, 2)
%   van_der_corput(1:10, 3)
%
% See also HALTON, HAMMERSLEY, UNITTEST_VAN_DER_CORPUT, RAND

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


assert(all(n(:)>=0))
assert(all(n(:)==round(n(:) )))

q = zeros(size(n));
f = 1/p;
while true
    r = rem(n, p);
    q = q + f * r;
    n = floor(n/p);
    if all(n(:)==0)
        break;
    end
    f = f/p;
end
