function unittest_check_tensors_compatible
% UNITTEST_CHECK_TENSORS_COMPATIBLE Test the CHECK_TENSORS_COMPATIBLE function.
%
% Example (<a href="matlab:run_example unittest_check_tensors_compatible">run</a>)
%   unittest_check_tensors_compatible
%
% See also CHECK_TENSORS_COMPATIBLE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'check_tensors_compatible' );

T2={rand(3,5), rand(7,5)};
T2b={rand(3,7), rand(7,7)};
T3={rand(3,5), rand(7,5), rand(9,5)};
T3b={rand(6,5), rand(7,5), rand(9,5)};
T3c={rand(3,5), rand(7,5), rand(5,5)};

assert_true( check_tensors_compatible(T2, T2b), 'ok_rank' );
assert_error( {@check_tensors_compatible, {T2, T3}}, 'tensor:.*order', 'order' );
assert_error( {@check_tensors_compatible, {T3, T3b}}, 'tensor:.*dimension', 'dimen1' );
assert_error( {@check_tensors_compatible, {T3, T3c}}, 'tensor:.*dimension', 'dimen2' );
