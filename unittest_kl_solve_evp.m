function unittest_kl_solve_evp
% UNITTEST_KL_SOLVE_EVP Test the KL_SOLVE_EVP function.
%
% Example (<a href="matlab:run_example unittest_kl_solve_evp">run</a>)
%    unittest_kl_solve_evp
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


munit_set_function( 'kl_solve_evp' );

x=linspace(0,1,11);
els=[(1:10)',(2:11)'];
C=covariance_matrix( x, {@gaussian_covariance, {0.3, 2}} );
M=mass_matrix( els, x );

[f,s]=kl_solve_evp( C, [], 3 );
assert_equals( size(f), [11,3] );
assert_equals( f'*f, eye(3) );
assert_equals( f'*C*f, diag(s.^2) );

[f,s]=kl_solve_evp( C, M, 4 );
assert_equals( size(f), [11,4] );
assert_equals( f'*M*f, eye(4) );
assert_equals( f'*M*C*M*f, diag(s.^2) );

fs=kl_solve_evp( C, [], 5, 'correct_var', true );
assert_equals( size(fs), [11,5] );
assert_equals( diag(fs*fs'), diag(C) );

fs=kl_solve_evp( C, M, 5, 'correct_var', true );
assert_equals( size(fs), [11,5] );
assert_equals( diag(fs*fs'), diag(C) );
