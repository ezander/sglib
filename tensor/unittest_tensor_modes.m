function unittest_tensor_modes
% UNITTEST_TENSOR_MODES Test the TENSOR_MODES function.
%
% Example (<a href="matlab:run_example unittest_tensor_modes">run</a>)
%   unittest_tensor_modes
%
% See also TENSOR_MODES, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_modes' );

T={rand(8,2), rand(10,2)};

s_ex=[norm(T{1}(:,1))*norm(T{2}(:,1));
    norm(T{1}(:,2))*norm(T{2}(:,2))];
assert_equals( tensor_modes( T, false ), s_ex, 'non_orth' );

s_ex=svd( T{1}*T{2}' );
s_ex=s_ex(1:2);
assert_equals( tensor_modes( T, true ), s_ex, 'orth' );





