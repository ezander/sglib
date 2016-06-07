function unittest_gpc_projection
% UNITTEST_GPC_PROJECTION Test the GPC_PROJECTION function.
%
% Example (<a href="matlab:run_example unittest_gpc_projection">run</a>)
%   unittest_gpc_projection
%
% See also GPC_PROJECTION, MUNIT_RUN_TESTSUITE 

%   <author>
%   Copyright 2014, <institution>
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpc_projection' );

%%
for p=0:5
    V = gpcbasis_create('hpl', 'p', p);
    r_i_alpha = rand(5, gpcbasis_size(V,1));
    r_func = gpc_function(r_i_alpha, V);
    
    r_i_alpha2 = gpc_projection(r_func, V, p+1);
    assert_equals(r_i_alpha2, r_i_alpha);
end

%%
V = gpcbasis_create('H', 'm', 2, 'p', 3);
a_i_alpha = gpc_rand_coeffs(V, 4);
a_func = gpc_function(a_i_alpha, V);
a_i_alpha2 = gpc_projection(a_func, V );
assert_equals(a_i_alpha, a_i_alpha2, 'coeffs');

xi = gpcgerm_sample(V, 10);
assert_equals(gpc_evaluate(a_i_alpha2, V, xi), funcall(a_func, xi), 'samples');
