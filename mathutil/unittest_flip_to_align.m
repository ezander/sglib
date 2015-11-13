function unittest_flip_to_align(varargin)
% UNITTEST_FLIP_TO_ALIGN Test the FLIP_TO_ALIGN function.
%
% Example (<a href="matlab:run_example unittest_flip_to_align">run</a>)
%   unittest_flip_to_align
%
% See also FLIP_TO_ALIGN, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2015, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'flip_to_align' );

x = linspace(0,1)';
F = [sin(x), cos(2*x), -sin(3*x)];
G = [sin(x), -cos(2*x), sin(3*x), cos(4*x)];

assert_equals(flip_to_align(F,G), G(:,1:3));

F = zeros(length(x), 0);
assert_equals(flip_to_align(F,G), F);
