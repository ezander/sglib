function unittest_gpcbasis_size
% UNITTEST_GPCBASIS_SIZE Test the GPCBASIS_SIZE function.
%
% Example (<a href="matlab:run_example unittest_gpcbasis_size">run</a>)
%   unittest_gpcbasis_size
%
% See also GPCBASIS_SIZE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpcbasis_size' );

% check basis size when only one polynomials system is specified
V = gpcbasis_create('L', 'm', 2, 'p', 6);
I = V{2};
[Ns_ex, m_ex] = size(I);

s = gpcbasis_size(V);
assert_equals(s, [Ns_ex, m_ex], 'ns');

Ns = gpcbasis_size(V,1);
assert_equals(Ns, Ns_ex, 'ns1');

m = gpcbasis_size(V,2);
assert_equals(m, m_ex, 'm');

[Ns,m] = gpcbasis_size(V);
assert_equals([Ns, m], [Ns_ex, m_ex], 'ns_m');

assert_error(funcreate(@gpcbasis_size,V,3), 'sglib:gpc', 'err_wrong_dim');
