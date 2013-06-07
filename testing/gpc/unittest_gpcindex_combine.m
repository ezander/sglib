function unittest_gpcindex_combine
% UNITTEST_GPCINDEX_COMBINE Test the GPCINDEX_COMBINE function.
%
% Example (<a href="matlab:run_example unittest_gpcindex_combine">run</a>)
%   unittest_gpcindex_combine
%
% See also GPCINDEX_COMBINE, TESTSUITE 

%   Elmar Zander
%   Copyright 2012, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'gpcindex_combine' );

% the gpcindex_combine function is not yet written, but the tests it should
% fulfill are already here.

function foo
p=4;
I1 = multiindex(3,2)
I2 = multiindex(2,4)
Iz=multiindex_product({I1, I2})
Iz0=multiindex_product_maxp({I1, I2},0)
Iz1=multiindex_product_maxp({I1, I2},1)
Iz2=multiindex_product_maxp({I1, I2},2)
Iz3=multiindex_product_maxp({I1, I2},3)
Iz4=multiindex_product_maxp({I1, I2},4)
Iz5=multiindex_product_maxp({I1, I2},5)
Iz6=multiindex_product_maxp({I1, I2},6)
1;

%different

% product
function I = multiindex_sum(Is)
I1 = Is{1};
I2 = Is{2};
n1 = size(I1,1);
n2 = size(I2,1);

[ind1,ind2] = meshgrid(1:n1, 1:n2);
I = [I1(ind1,:), I2(ind2,:)];

function I = multiindex_product(Is)
I1 = Is{1};
I2 = Is{2};
n1 = size(I1,1);
n2 = size(I2,1);

[ind1,ind2] = meshgrid(1:n1, 1:n2);
I = [I1(ind1,:), I2(ind2,:)];

% product_maxp
function I=multiindex_product_maxp(Is, p)
I1 = Is{1};
I2 = Is{2};
d1 = multiindex_order(I1);
d2 = multiindex_order(I2);
[D1,D2] = meshgrid(d1, d2);
ind=(D1+D2<=p);
[ind1,ind2] = meshgrid(1:size(I1,1), 1:size(I2,1));
I = [I1(ind1(ind),:), I2(ind2(ind),:)];

% sort 

% sum

% union, 


return
function foo
I1a = multiindex(3,2);
I1b = multiindex(3,4);
I2 = multiindex(2,4);

gpcindex_combine( {'H', I1a}, {'H', I1b}, 'directsum');
gpcindex_combine( {'H', I1a}, {'H', I1b}, 'product_min');
gpcindex_combine( {'H', I1a}, {'H', I1b}, 'product_tensor');
gpcindex_combine( {'H', I1a}, {'H', I1b}, 'product_mp');


% 1. add two random variables on same V1a, V1b subset V1
% 2. add two random variables on V1, V2 independent, minimum V3
% 3. same as 2, "full" V3
% 4. multiply two random variables on V1a, V1b, min exact subset
% 5. multiply two random variables on V1a, V1b, truncate subset
% 6. multiply two random variables on V1a, V1b, containing subset
% 7. same as 4-6 with V1, V2
% 8. full tensor subset
% 9. sparse tensor subset
% 10. localisation of V1a, V1b, V1, V2 in V3
% 11. combine two random variables and random fields

% gpc_add
% gpc_multiply
% gpc_combine (stack)
% gpc_unary_func, gpc_binary_func
% gpc_integrate


% gpcspace_create
% gpcspace_product
% gpcspace_direct_sum
