function unittest_smolyak_grid
% UNITTEST_SMOLYAK_GRID Test the SMOLYAK_GRID function.
%
% Example (<a href="matlab:run_example unittest_smolyak_grid">run</a>)
%   unittest_smolyak_grid
%
% See also SMOLYAK_GRID, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'smolyak_grid' );

% for this ugly hack see 'unittest_full_tensor_grid.m' (for short: we
% import some private functions here, don't do that at home...)
[polyint_rule, polyint_legendre, polyint_gauss, polyint_mixed]=unittest_full_tensor_grid( 'export' );

% test 1: check sizes and simple features
[xd,wd]=smolyak_grid( 2, 7, @gauss_hermite_rule );
assert_equals( size(xd), [2,137], 'size_xd_27' );
assert_equals( size(wd), [137,1], 'size_wd_27' );
assert_equals( sum(wd), 1, 'sum_wd_27' );
[xd,wd]=smolyak_grid( 2, 9, @gauss_hermite_rule );
assert_equals( size(xd), [2,281], 'size_xd_29' );
assert_equals( size(wd), [281,1], 'size_wd_29' );
assert_equals( sum(wd), 1, 'sum_wd_29' );


% test 5: test for polynomials using gauss legendre quadrature
% polyint_rule integrates using the rule, polyint_legendre does analytic integration
% test 5a: for 2 vars and 2 stage rule (integrate exactly up to deg. 3)
[xd,wd]=smolyak_grid( 2, 2, @gauss_legendre_rule );
a=[1, 10, 100];
assert_equals( polyint_rule( 1, a, xd, wd ), polyint_legendre( 1, a, 2 ), 'gl_int2_1' );
a=[0,0,0,1, 10, 100];
assert_equals( polyint_rule( 2, a, xd, wd ), polyint_legendre( 2, a, 2 ), 'gl_int2_2' );
a=[0,0,0,0,0,0,1, 10, 100,1000];
assert_equals( polyint_rule( 3, a, xd, wd ), polyint_legendre( 3, a, 2 ), 'gl_int2_3' );
% test 5b: for 2 vars and 3 stage rule (integrate exactly up to deg. 5)
[xd,wd]=smolyak_grid( 2, 3, @gauss_legendre_rule );
a=rand(1,nchoosek(2+4,2));
assert_equals( polyint_rule( 4, a, xd, wd ), polyint_legendre( 4, a, 2 ), 'gl_int2_4' );
a=rand(1,nchoosek(2+5,2));
assert_equals( polyint_rule( 5, a, xd, wd ), polyint_legendre( 5, a, 2 ), 'gl_int2_5' );
% test 5b: for 4 vars and 4 stage rule (integrate exactly up to deg. 7)
[xd,wd]=smolyak_grid( 4, 4, @gauss_legendre_rule );
a=rand(1,nchoosek(4+7,4));
assert_equals( polyint_rule( 7, a, xd, wd ), polyint_legendre( 7, a, 4 ), 'gl_int4_4' );


% test 6: test for polynomials using gauss hermite quadrature
[xd,wd]=smolyak_grid( 3, 3, @gauss_hermite_rule );
a=rand(1,nchoosek(3+5,3));
assert_equals( polyint_rule( 5, a, xd, wd ), polyint_gauss( 5, a, 3 ), 'gh_int3_3' );


% test 6: test for polynomials using mixed hermite/legendre quadrature
[xd,wd]=smolyak_grid( 3, 3, {@gauss_hermite_rule, @gauss_legendre_rule, @gauss_hermite_rule} );
a=rand(1,nchoosek(3+5,3));
assert_equals( polyint_rule( 5, a, xd, wd ), polyint_mixed( 5, a, 3, [1, 3] ), 'gh_mixed_hlh' );
[xd,wd]=smolyak_grid( 3, 3, {@gauss_legendre_rule, @gauss_hermite_rule, @gauss_legendre_rule} );
a=rand(1,nchoosek(3+5,3));
assert_equals( polyint_rule( 5, a, xd, wd ), polyint_mixed( 5, a, 3, 2 ), 'gh_mixed_lhl' );

