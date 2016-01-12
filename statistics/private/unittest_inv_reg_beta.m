function unittest_inv_reg_beta
% UNITTEST_INV_REG_BETA Test the inverse regularized beta function.
%
% Example (<a href="matlab:run_example unittest_inv_reg_beta">run</a>)
%    unittest_inv_reg_beta
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'inv_reg_beta' );

% do for a small set for which there is no interpolation
do_test( 1, 1, 20, 'small_11' );
do_test( 1, 1, 10000, 'large_11' );

do_test( 4, 2, 20, 'small_42' );
do_test( 4, 2, 10000, 'large_42' );

do_test( .2, .9, 20, 'small_0209' );
do_test( .2, .9, 10000, 'large_0209' );

do_test( .4, .2, 10, 'small_0402', 'abstol', 1e-4  );
do_test( .4, .2, 10, 'small_0402', 'abstol', 1e-4  );

assert_equals( inv_reg_beta( linspace(0,1,10), 0.000001, 0.000001 ), [0,0,0,0,0,1,1,1,1,1], 'small' );
assert_error( 'inv_reg_beta( [0,1], 1e4, 1e4 )', 'util:inv_reg_beta', 'error_too_large' );

% same values 
do_test( 4, 2, repmat(0.4, 1, 20), 'small_same' );
do_test( 4, 2, repmat(0.4, 1, 10000), 'large_same' );

function do_test( a, b, N_or_y, id, varargin )
if isscalar(N_or_y)
    N=N_or_y;
    y=linspace(0,1,N);
else
    N=length(N_or_y);
    y=N_or_y;
end
x=inv_reg_beta( y, a, b );
y2=x; notnan=~isnan(x);
y2(notnan)=betainc(x(notnan),a, b);
assert_equals( y, y2, id, varargin{:} );
