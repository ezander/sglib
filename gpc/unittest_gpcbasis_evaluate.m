function unittest_gpcbasis_evaluate
% UNITTEST_GPCBASIS_EVALUATE Test the GPCBASIS_EVALUATE function.
%
% Example (<a href="matlab:run_example unittest_gpcbasis_evaluate">run</a>)
%   unittest_gpcbasis_evaluate
%
% See also GPCBASIS_EVALUATE, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'gpcbasis_evaluate' );

V = {'H', multiindex(3,5)};
y = gpcbasis_evaluate(V, rand(3, 10));
assert_equals(size(y), [size(V{2},1), 10], 'size');


% for Legendre this is relatively easy to test at -1 and 1
I = multiindex(3,5);
V = {'P', I};
y = gpcbasis_evaluate(V, [ones(3,1), -ones(3,1)]);
p = multiindex_order(I);
y_ex = [ones(size(p)), (-1).^p];

assert_equals(y, y_ex, 'legendre');

% test dual basis for Legendre
yd = gpcbasis_evaluate(V, [ones(3,1), -ones(3,1)], 'dual', true);
n = gpcbasis_norm(V, 'sqrt', false);
yd_ex = binfun(@rdivide, [ones(size(p)), (-1).^p], n)';

assert_equals(yd, yd_ex, 'legendre_dual');
