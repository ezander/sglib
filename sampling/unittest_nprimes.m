function unittest_nprimes
% UNITTEST_NPRIMES Test the NPRIMES function.
%
% Example (<a href="matlab:run_example unittest_nprimes">run</a>)
%   unittest_nprimes
%
% See also NPRIMES, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'nprimes' );

pr = primes(10000);

assert_equals(nprimes(0), pr(1:0), 'np0');
assert_equals(nprimes(1), pr(1:1), 'np1');
assert_equals(nprimes(2), pr(1:2), 'np2');
assert_equals(nprimes(4), pr(1:4), 'np4');
assert_equals(nprimes(40), pr(1:40), 'np40');
assert_equals(nprimes(1000), pr(1:1000), 'np1000');

p = nprimes(77);
assert_equals(length(p), 77);
assert_equals(isprime(p), true(1,77));
