function unittest_hermite_triples
% UNITTEST_HERMITE_TRIPLES Test the HERMITE_TRIPLE_PRODUCT and HERMITE_TRIPLE_FAST functions.
%
% Example (<a href="matlab:run_example unittest_hermite_triples">run</a>)
%    unittest_hermite_triples
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


% Test the hermite_triple_product function
munit_set_function( 'hermite_triple_product' );
t=zeros(6,6,3);
for k=0:2;
    for i=0:5;
        for j=0:5;
            t(i+1,j+1,k+1)=hermite_triple_product(i,j,k);
        end;
    end;
end

assert_equals( t(:,:,1), diag([1,1,2,6,24,120]), 'univariate' );
assert_equals( t(:,:,2), diag([1,2,6,24,120],-1)+diag([1,2,6,24,120],1), 'univariate' );
assert_equals( t(:,:,3), diag([2,6,24,120],-2)+diag([0,2,8,36,192,1200])+diag([2,6,24,120],2), 'univariate' );


assert_equals( hermite_triple_product([1 1],[2 2],[3 3]), 36, 'multivariate' );
assert_equals( hermite_triple_product([1 2],[2 3],[3 4]), 0, 'multivariate' );
assert_equals( hermite_triple_product([1 2],[2 3],[3 5]), 720, 'multivariate' );



% Test the hermite_triple_fast function
munit_set_function( 'hermite_triple_fast' );
hermite_triple_fast(5);
t=zeros(6,6,3);
for k=0:2;
    for i=0:5;
        for j=0:5;
            t(i+1,j+1,k+1)=hermite_triple_fast(i,j,k);
        end;
    end;
end

assert_equals( t(:,:,1), diag([1,1,2,6,24,120]), 'univariate' );
assert_equals( t(:,:,2), diag([1,2,6,24,120],-1)+diag([1,2,6,24,120],1), 'univariate' );
assert_equals( t(:,:,3), diag([2,6,24,120],-2)+diag([0,2,8,36,192,1200])+diag([2,6,24,120],2), 'univariate' );

% test the multivariate triples (i.e. multiindices)
assert_equals( hermite_triple_fast([1 1],[2 2],[3 3]), 36, 'multivariate' );

assert_equals( hermite_triple_fast([1 2],[2 3],[3 3]), 216, 'multivariate' );
assert_equals( hermite_triple_fast([1 2],[2 3],[3 4]), 0, 'multivariate' );
assert_equals( hermite_triple_fast([1 2],[2 3],[3 5]), 720, 'multivariate' );

% test with vectors of multiindices
assert_equals( squeeze(hermite_triple_fast([1 2],[2 3],[3 3; 3 4; 3 5])), [216;0;720], 'multivariate/kvec' );
assert_equals( squeeze(hermite_triple_fast([1 2],[4 3],[3 3; 3 4; 3 5])), [864;0;2880], 'multivariate/kvec' );
assert_equals( squeeze(hermite_triple_fast([1 2],[2 2],[3 3; 3 4; 3 5])), [0;144;0], 'multivariate/kvec' );
assert_equals( squeeze(hermite_triple_fast([1 2],[2 3; 4 3; 2 2],[3 3; 3 4; 3 5])), [216,0,720; 864,0,2880; 0,144,0], 'multivariate/jkvec' );
assert_equals( squeeze(hermite_triple_fast(1,[2; 4; 2],[3; 3; 3])), [6,6,6; 24,24,24; 6,6,6], 'multivariate/jkvec' );
