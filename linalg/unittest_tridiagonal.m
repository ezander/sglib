function unittest_tridiagonal
% UNITTEST_TRIDIAGONAL Test the TRIDIAGONAL function.
%
% Example (<a href="matlab:run_example unittest_tridiagonal">run</a>)
%   unittest_tridiagonal
%
% See also TRIDIAGONAL, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'tridiagonal' );

A=tridiagonal(7,3,2,5);
assert_equals(size(A),[7,7], 'full_size');
assert_equals(diag(A),repmat(3,7,1), 'full_diag');
assert_equals(diag(A,1),repmat(2,6,1), 'full_super');
assert_equals(diag(A,-1),repmat(5,6,1), 'full_sub');

As = tridiagonal(7,3,2,5, 'sparse', true);
assert_matrix(As,'sparse', 'issparse');
assert_equals(As, A, 'sparse');

Av=tridiagonal(7,repmat(3,7,1),repmat(2,6,1),repmat(5,6,1));
assert_matrix(Av,'full', 'vec_full');
assert_equals(Av, A, 'vec_init');

Avs=tridiagonal(7,repmat(3,7,1),repmat(2,6,1),repmat(5,6,1), 'sparse', true);
assert_matrix(Avs,'sparse', 'sparse_vec');
assert_equals(Avs, A, 'sparse_vec_init');


