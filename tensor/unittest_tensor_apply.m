function unittest_tensor_apply
% UNITTEST_TENSOR_APPLY Test the TENSOR functions.
%
% Example (<a href="matlab:run_example unittest_tensor_apply">run</a>)
%    unittest_tensor_apply
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_apply' );

T={rand(8,3), rand(10,3)};
A={rand(8,8), rand(10,10)};
B={@(x)(A{1}*x), @(x)(A{2}*x)};
C={A{1}, @(x)(A{2}*x)};
UA=tensor_apply(A,T);
UB=tensor_apply(B,T);
UC=tensor_apply(C,T);
assert_equals( UA{1}*UA{2}', UB{1}*UB{2}' );
assert_equals( UA{1}*UA{2}', UC{1}*UC{2}' );

