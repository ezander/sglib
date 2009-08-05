function test_inv_reg_beta
% TEST_INV_REG_BETA Test the inverse regularized beta function.
%
% Example (<a href="matlab:run_example test_inv_reg_beta">run</a>) 
%    test_inv_reg_beta
%
% See also TESTSUITE

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


assert_set_function( 'inv_reg_beta' );

% do for a small set for which there is no interpolation
do_test( 1, 1, 20, 'small_11' );
do_test( 1, 1, 10000, 'large_11' );

do_test( 4, 2, 20, 'small_42' );
do_test( 4, 2, 10000, 'large_42' );

do_test( .2, .9, 20, 'small_0209' );
do_test( .2, .9, 10000, 'large_0209' );

% this test is very hard since betainc is very steep at the sides and it a
% long while for the algorithm to converge
do_test( .4, .2, 20, 'small_0402', 'abstol', 1e-4  );
%do_test( .4, .2, 10000, 'large_0402', 'abstol', 1e-4  );


function do_test( a, b, N, id, varargin )
y=linspace(0,1,N);
x=inv_reg_beta( y, a, b );
y2=x; notnan=~isnan(x);
y2(notnan)=betainc(x(notnan),a, b);
assert_equals( y, y2, id, varargin{:} );
