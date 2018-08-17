function unittest_ppder(varargin)
% UNITTEST_PPDER Test the PPDER function.
%
% Example (<a href="matlab:run_example unittest_ppder">run</a>)
%   unittest_ppder
%
% See also PPDER, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2018, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'ppder' );


x = linspace(0, 1, 100);
xi = linspace(0, 1, 10);

f = @sin;
df = @cos;
pp = interp1(xi, f(xi), 'spline', 'pp');
ppd = ppder(pp);

assert_equals(ppval(pp,x), f(x), 'f_sin', 'abstol', 0.01) % just to make sure
assert_equals(ppval(ppd,x), df(x), 'df_sin', 'abstol', 0.01)



f = @(x) polyval([2, 5, 3, 1], x);
df = @(x) polyval([6, 10, 3], x);
pp = interp1(xi, f(xi), 'spline', 'pp');
ppd = ppder(pp);
%assert_equals(ppval(pp,x), f(x), 'f_poly')
assert_equals(ppval(ppd,x), df(x), 'df_poly')





