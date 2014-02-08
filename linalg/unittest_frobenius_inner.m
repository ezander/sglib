function unittest_frobenius_inner
% UNITTEST_FROBENIUS_INNER Test the FROBENIUS_INNER function.
%
% Example (<a href="matlab:run_example unittest_frobenius_inner">run</a>)
%   unittest_frobenius_inner
%
% See also FROBENIUS_INNER, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'frobenius_inner' );

N=30; M=20;
A=rand(N,M);
B=rand(N,M);
assert_equals( frobenius_inner(A,B), trace(A'*B), 'full1' );

A=sparse(A); B=sparse(B);
assert_equals( frobenius_inner(A,B), trace(A'*B), 'sparse1' );

A=rand(N,M);
B=rand(N,M);
A(A<.8)=0;
B(B<.8)=0;
assert_equals( frobenius_inner(A,B), trace(A'*B), 'full2' );

A=sparse(A); B=sparse(B);
assert_equals( frobenius_inner(A,B), trace(A'*B), 'sparse2' );

