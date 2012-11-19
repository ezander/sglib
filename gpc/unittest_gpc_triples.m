function unittest_gpc_triples
% UNITTEST_GPC_TRIPLES Test the GPC_TRIPLES function.
%
% Example (<a href="matlab:run_example unittest_gpc_triples">run</a>)
%   unittest_gpc_triples
%
% See also GPC_TRIPLES, TESTSUITE 

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

munit_set_function( 'gpc_triples' );


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


function test_mult(sys,m)
    if nargin<2
        m = length(sys);
    end
    p = 3;
    n = 5;
    k = 3;
    V_x = {sys, multiindex(m, p)};
    V_y = {sys, multiindex(m, p)};
    V_z = {sys, multiindex(m, 2*p)};
    x_i_alpha = rand(n, size(V_x{2},1));
    y_i_alpha = rand(n, size(V_y{2},1));
    
    M = gpc_triples(V_x, V_y, V_z);
    z_k_gamma=zeros(n,size(V_z{2},1));
    for i=1:n
        aaa = tensor_multiply( M, y_i_alpha(i,:), 2, 2 );
        bbb = tensor_multiply( x_i_alpha(i,:), aaa, 2, 1 );
        z_k_gamma(i,:)=bbb;
    end
    z_k_gamma=row_col_mult( z_k_gamma, (1./gpc_norm(V_z)').^2 );
    
    xi = gpc_sample(V_x, n);
    assert_equals(gpc_evaluate(z_k_gamma, V_z, xi), ...
        gpc_evaluate(x_i_alpha, V_x, xi) .* gpc_evaluate(y_i_alpha, V_y, xi), ['mult_', sys]);




