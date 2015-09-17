function unittest_covariance_decomp(varargin)
% UNITTEST_COVARIANCE_DECOMP Test the COVARIANCE_DECOMP function.
%
% Example (<a href="matlab:run_example unittest_covariance_decomp">run</a>)
%   unittest_covariance_decomp
%
% See also COVARIANCE_DECOMP, MUNIT_RUN_TESTSUITE 

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

munit_set_function( 'covariance_decomp' );

rng('default');
rng(5099);

A = rand(7, 4);
C = A*A';
C = 0.5 * (C + C');

L=covariance_decomp(C);
assert_equals(L*L', C, 'decom');
assert_equals(size(L), size(A), 'size');

L=covariance_decomp(C, 'fillup', true);
assert_equals(L*L', C, 'decom');
assert_equals(size(L), size(C), 'size');

L=covariance_decomp(C, 'always_lower', true);
assert_equals(L*L', C, 'decom');
assert_equals(size(L), size(A), 'size');
assert_matrix(L, 'lower', 'lower');
