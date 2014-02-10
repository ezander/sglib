function unittest_interpolatory_weights
% UNITTEST_INTERPOLATORY_WEIGHTS Test the INTERPOLATORY_WEIGHTS function.
%
% Example (<a href="matlab:run_example unittest_interpolatory_weights">run</a>)
%   unittest_interpolatory_weights
%
% References
%   [1] https://en.wikipedia.org/wiki/Newton-Cotes_formulas
%
% See also INTERPOLATORY_WEIGHTS 

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

munit_set_function( 'interpolatory_weights' );

% simple tests
assert_equals(interpolatory_weights(0), 2, 'one');
assert_equals(interpolatory_weights([-0.5, 0.5]), [1; 1], 'twoa');
assert_equals(interpolatory_weights([-0.3, 0.3]), [1; 1], 'twob');

% reproduce closed Newton-Cotes formulae (degree 1 contained in simple
% tests)
assert_equals(interpolatory_weights([-1, 0, 1]), [1; 4; 1]/3, 'closed_nc_2');
assert_equals(interpolatory_weights([-1, -1/3, 1/3, 1]), [1; 3; 3; 1]/4, 'closed_nc_3');
assert_equals(interpolatory_weights([-1, -1/2, 0, 1/2, 1]), [7; 32; 12; 32; 7]/45, 'closed_nc_4');

% reproduce open Newton-Cotes formulae (degrees 1 and 2 contained in simple
% tests)
assert_equals(interpolatory_weights([-1/2, 0, 1/2]), [2; -1; 2]*2/3, 'open_nc_3');
assert_equals(interpolatory_weights([-3/5, -1/5, 1/5, 3/5]), [11; 1; 1; 11]/12, 'open_nc_4');


% reproduce Gauss-Legendre and Clenshaw-Curtis rules
[x,w]=gauss_legendre_rule(4);
assert_equals(interpolatory_weights(x), w, 'gl4');

[x,w]=clenshaw_curtis_rule(5);
assert_equals(interpolatory_weights(x), w, 'cc5');

% test different algorithms and scaling
[x,w]=clenshaw_curtis_rule(7);
assert_equals(interpolatory_weights(x, 'algorithm', 'lagrange'), w, 'cc7_lag');
assert_equals(interpolatory_weights(x, 'algorithm', 'vandermonde'), w, 'cc7_van');
assert_equals(interpolatory_weights(2*x+3, 'interval', [1, 5]), 2*w, 'cc7_shift');
