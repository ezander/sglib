function unittest_revkron
% UNITTEST_REVKRON Test the REVKRON and function.
%
% Example (<a href="matlab:run_example unittest_revkron">run</a>)
%    unittest_revkron
%
% See also REVKRON, MUNIT_RUN_TESTSUITE

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


munit_set_function( 'revkron' );

M1=3; N1=4;
M2=2; N2=5;
A={ rand(N1,M1), rand(N2,M2); rand(N1,M1), rand(N2,M2); rand(N1,M1), rand(N2,M2) };

S1=kron(A{1,2},A{1,1});
S2=kron(A{2,2},A{2,1});
S3=kron(A{3,2},A{3,1});

assert_equals( revkron(A{1,1}, A{1,2}), S1, 'norm' );
assert_equals( revkron(A{1,:}), S1, 'single' );

s=warning( 'off', 'revrkon:deprecated' );
assert_equals( revkron(A), S1+S2+S3, 'multiple' );
warning(s);
