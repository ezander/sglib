function unittest_ppint(varargin)
% UNITTEST_PPINT Test the PPINT function.
%
% Example (<a href="matlab:run_example unittest_ppint">run</a>)
%   unittest_ppint
%
% See also PPINT, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'ppint' );

% Test with sin and cosine
x = linspace(0, 1, 100);
xi = linspace(0, 1, 10);

f = @cos;
F = @sin;
pp = interp1(xi, f(xi), 'spline', 'pp');
ppi = ppint(pp);
assert_equals(ppval(ppi,x), F(x), 'F_sin', 'abstol', 0.01) 


% With a polynomial (with zero constant term)
f = @(x) polyval([6, 10, 3], x);
F = @(x) polyval([2, 5, 3, 0], x);
pp = interp1(xi, f(xi), 'spline', 'pp');
ppi = ppint(pp);
assert_equals(ppval(ppi,x), F(x), 'F_poly')


% With a polynomial with nonzero constant term on different interval
x = linspace(2, 4, 100);
xi = linspace(2, 4, 10);

f = @(x) polyval([6, 10, 3], x);
F = @(x) polyval([2, 5, 3, 2], x);
pp = interp1(xi, f(xi), 'spline', 'pp');
ppi = ppint(pp, F(min(x)));
assert_equals(ppval(ppi,x), F(x), 'F_poly')
