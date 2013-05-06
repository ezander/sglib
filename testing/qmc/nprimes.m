function p=nprimes(m)
% NPRIMES Return a list with an exact number of primes.
%   P=NPRIMES(M) returns a list of exactly M prime numbers (in contrast to
%   the matlab PRIME function that would return primes up to M). NPRIMES
%   uses the prime number theorem to estimate the maximum prime number N
%   that will be needed and then calls PRIMES(N). The list is then
%   truncated to the right size M. (In the improbable case that N should be
%   too small, it is increased until enough prime numbers are generated).
%
% Example (<a href="matlab:run_example nprimes">run</a>)
%   nprimes(5)
%
% See also PRIMES

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


if m==0
    p=zeros(1,0);
    return
end
% follows from prime number theorem plus some fitting (i.e. the number of
% of primes smaller than n  is always slightly larger than m)
n = m * log(m) * 1.2 + 3;
p = primes(n);
% the following loop should never execute (its just a precaution, since the
% formula for n above is not guaranteed)
while length(p)<m
    n = n * 2;
    p = primes(n);
end
p = p(1:m);
   

