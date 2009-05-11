function test_apply_linear_operator
% TEST_APPLY_LINEAR_OPERATOR Test the APPLY_LINEAR_OPERATOR function.
%
% Example 
%    test_apply_linear_operator
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'apply_linear_operator' );


% there is not much point in bigger matrices here, just check that basic
% functionality works
M=[1, 2; 3, 4; 5, 10];
x=[1; 5];
y=M*x;

assert_equals( apply_linear_operator( M ), [3,2], 'M_size' );
assert_equals( apply_linear_operator( M, [] ), [3,2], 'M_size' );
assert_equals( apply_linear_operator( M, x ), y, 'M' );

func={ @doit, {M}, {1} };
assert_equals( apply_linear_operator( func ), [3,2], 'func_size' );
assert_equals( apply_linear_operator( func, [] ), [3,2], 'func_size' );
assert_equals( apply_linear_operator( func, x ), y, 'func' );


func={ @apply_linear_operator, {M}, {1} };
assert_equals( apply_linear_operator( func ), [3,2], 'rec_size' );
assert_equals( apply_linear_operator( func, [] ), [3,2], 'rec_size' );
assert_equals( apply_linear_operator( func, x ), y, 'rec' );


function y=doit( M, x )
if isempty(x)
    y=size(M);
else
    y=M*x;
end
