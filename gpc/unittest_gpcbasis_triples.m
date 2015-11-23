function unittest_gpcbasis_triples
% UNITTEST_GPCBASIS_TRIPLES Test the GPCBASIS_TRIPLES function.
%
% Example (<a href="matlab:run_example unittest_gpcbasis_triples">run</a>)
%   unittest_gpcbasis_triples
%
% See also GPCBASIS_TRIPLES, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2012, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpcbasis_triples' );


test_mult('H')
test_mult('h')
test_mult('P')
test_mult('p')
test_mult('T')
test_mult('t')
test_mult('U')
test_mult('u')
test_mult('L')
test_mult('l')

test_mult('P', 2)
test_mult('Ph')
test_mult('pPhH')
test_mult('tu')
test_mult('luUL')


function test_mult(syschars,m)
    if nargin<2
        m = length(syschars);
    end
    p = 3;
    n = 5;
    k = 3;
    V_x = {syschars, multiindex(m, p)};
    V_y = {syschars, multiindex(m, p)};
    V_z = {syschars, multiindex(m, 2*p)};
    x_i_alpha = rand(n, size(V_x{2},1));
    y_i_alpha = rand(n, size(V_y{2},1));
    
    M = gpcbasis_triples(V_x, V_y, V_z);
    z_k_gamma=zeros(n,size(V_z{2},1));
    for i=1:n
        aaa = tensor_multiply( M, y_i_alpha(i,:), 2, 2 );
        bbb = tensor_multiply( x_i_alpha(i,:), aaa, 2, 1 );
        z_k_gamma(i,:)=bbb;
    end
    z_k_gamma=row_col_mult( z_k_gamma, (1./gpcbasis_norm(V_z)').^2 );
    
    xi = gpcgerm_sample(V_x, k);
    assert_equals(gpc_evaluate(z_k_gamma, V_z, xi), ...
        gpc_evaluate(x_i_alpha, V_x, xi) .* gpc_evaluate(y_i_alpha, V_y, xi), ['mult_', syschars]);
