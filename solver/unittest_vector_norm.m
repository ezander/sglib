function unittest_vector_norm
% UNITTEST_VECTOR_NORM Test the VECTOR functions.
%
% Example (<a href="matlab:run_example unittest_vector_norm">run</a>)
%    unittest_vector_norm
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

munit_set_function( 'vector_norm' );

T={rand(8,2), rand(10,2)};
normT=norm( T{1}*T{2}', 'fro' );
normT2=sqrt(trace( T{1}*T{2}'*T{2}*T{1}' ));
assert_equals( normT, normT2, 'check_test' );
assert_equals( vector_norm( T ), normT, 'inner' );

T={rand(8,2), rand(10,2), rand(12,2)};
Z=vector_add(T,T,-1);
assert_equals( vector_norm( Z ), 0, 'zero_inner3', 'abstol', 1e-7 );

T={rand(8,2), rand(10,2)};
M1=rand(8); M1=M1*M1';
M2=rand(10); M2=M2*M2';
normT=sqrt(trace( M1*T{1}*T{2}'*M2*T{2}*T{1}' ));
assert_equals( vector_norm( T,  {M1, M2} ), normT, 'inner' );

