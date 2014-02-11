function unittest_tensor_operator_create
% UNITTEST_TENSOR_OPERATOR_CREATE Test the TENSOR_OPERATOR_CREATE function.
%
% Example (<a href="matlab:run_example unittest_tensor_operator_create">run</a>)
%   unittest_tensor_operator_create
%
% See also TENSOR_OPERATOR_CREATE, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_operator_create' );

K=cell(1,5);
X=cell(1,5);
Y=cell(1,5);
for i=1:5; 
    K{i}=rand(10);
    X{i}=rand(20);
    Y{i}=rand(23); 
end

A = tensor_operator_create({K,X});
assert_equals(size(A), [5,2], 'size');
assert_equals(A{1,1}, K{1}, 'A11');
assert_equals(A{5,2}, X{5}, 'A52');

A = tensor_operator_create({K,X,Y});
assert_equals(size(A), [5,3], 'size3');
assert_equals(A{4,3}, Y{4}, 'A43');

