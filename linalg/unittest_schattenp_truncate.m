function unittest_schattenp_truncate
% UNITTEST_SCHATTENP_TRUNCATE Test the SCHATTENP_TRUNCATE function.
%
% Example (<a href="matlab:run_example unittest_schattenp_truncate">run</a>)
%    unittest_schattenp_truncate
%
% See also SCHATTENP_TRUNCATE, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2007-2014, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


munit_set_function( 'schattenp_truncate' );

% Check precomputed values with short sigma vector 
s=[5,4,3,2,1];
assert_equals( schattenp_truncate( s, 6, false, inf ), 0 );
assert_equals( schattenp_truncate( s, 5, false, inf ), 1 );
assert_equals( schattenp_truncate( s, 4.5, false, inf ), 1 );
assert_equals( schattenp_truncate( s, 4, false, inf ), 2 );
assert_equals( schattenp_truncate( s, 1.5, false, inf ), 4 );
assert_equals( schattenp_truncate( s, 0.5, false, inf ), 5 );
assert_equals( schattenp_truncate( s, 0, false, inf ), 5 );

assert_equals( schattenp_truncate( s, 4, false, 2 ), 2 );
assert_equals( schattenp_truncate( s, sqrt(5), false, 2 ), 3 );
assert_equals( schattenp_truncate( s, 2, false, 2 ), 4 );
assert_equals( schattenp_truncate( s, 1, false, 2 ), 4 );
assert_equals( schattenp_truncate( s, 0, false, 2 ), 5 );

assert_equals( schattenp_truncate( s, 4, false, 1 ), 3 );
assert_equals( schattenp_truncate( s, 3, false, 1 ), 3 );
assert_equals( schattenp_truncate( s, 2.5, false, 1 ), 4 );

% Now we take a long sigma vector with big differences in absolute value, so that
% precision/truncation errors play a role. 
s=[2000; 1000; ones(48,1)]+0.01*(50:-1:1)'; 

for k=[1,3,5,20,48]
    for p=[1,2,3,5,inf]
        abseps=0.5*(norm(s(k:end),p)+norm(s(k+1:end),p));
        releps=abseps/norm(s,p);
        top=sprintf( 'spt-k_%d-p%d', k, p );
        assert_equals( schattenp_truncate( s, abseps, false, p ), k, [top '-abs'] );
        assert_equals( schattenp_truncate( s, releps, true, p ), k, [top '-rel'] );
    end
end
 
 % special case: schatten infinity norm with repeated values (can make
 % problems because the error norm is then not strictly decreasing with
 % increasing k)
s=[2000; 1000; ones(48,1)]; 
sinf=max(s); 
assert_equals( schattenp_truncate( s, 1000.5, false, inf ), 1 );
assert_equals( schattenp_truncate( s, 1000.5/sinf, true, inf ), 1 );
assert_equals( schattenp_truncate( s, 1.5, false, inf ), 2 );
assert_equals( schattenp_truncate( s, 1.5/sinf, true, inf ), 2 );
assert_equals( schattenp_truncate( s, 0.5/sinf, true, inf ), 50 );


% some more special cases
% Sigma empty, then there's nothing to truncate
k=schattenp_truncate( [], 1.2, false, 3, 20 );
assert_equals(k, 0, 'empty');

