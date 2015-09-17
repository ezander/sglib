function varargout=unittest_full_tensor_grid( varargin )
% UNITTEST_FULL_TENSOR_GRID Test the FULL_TENSOR_GRID function.
%
% Example (<a href="matlab:run_example unittest_full_tensor_grid">run</a>)
%   unittest_full_tensor_grid
%
% See also FULL_TENSOR_GRID, MUNIT_RUN_TESTSUITE 

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% <ugly_hack>
% If there is one arg to this function which equals the string 'export'
% then we export the internal functions (which are used in the smolyak unit
% tests, may some day they should be made public)
if length(varargin)==1 && strcmp( varargin{1}, 'export' );
    varargout={ @polyint_rule, @polyint_legendre, @polyint_gauss, @polyint_mixed };
    return
end
% </ugly_hack>


munit_set_function( 'full_tensor_grid' );

% test 1: dummy in dim 1 should give the same as the rule itself
[xd,wd]=full_tensor_grid( 1, 5, @dummy_rule );
[x5,w5]=dummy_rule(5);
assert_equals( xd, x5, 'xd_1' );
assert_equals( wd, w5, 'wd_1' );

% test 2: dummy in dim 2 with same stages
[xd,wd]=full_tensor_grid( 2, 5, @dummy_rule );
assert_equals( sum(xd,2), [0;0], 'sum_xd_2' );
assert_equals( sum(wd), 1, 'sum_wd_2' );
[X,Y]=meshgrid( dummy_rule(5) );
assert_equals( sortrows(xd'), [X(:),Y(:)], 'xd_2' );

% test 3: dummy in dim 2 with diff stages
[xd,wd]=full_tensor_grid( 2, [3 6], @dummy_rule );
assert_equals( sum(xd,2), [0;0], 'sum_xd_2b' );
assert_equals( sum(wd), 1, 'sum_wd_2b' );
[X,Y]=meshgrid( dummy_rule(3), dummy_rule(6) );
assert_equals( sortrows(xd'), [X(:),Y(:)], 'sum_xd_2b' );

% test 4: dummy in dim 7
[xd,wd]=full_tensor_grid( 7, [4 3 2 2 2 2 2], @dummy_rule );
assert_equals( norm(sum(xd,2)), 0, 'sum_xd_4' );
assert_equals( sum(wd), 1, 'sum_wd_4' );
assert_equals( numel(wd), 384, 'numel_wd_4' );
assert_equals( numel(xd), 7*384, 'numel_xd_4' );


% test 5: test for polynomials using gauss legendre quadrature
% polyint_rule integrates using the rule, polyint_legendre does analytic integration
% test 5a: for 2 vars and 2 stage rule (integrate exactly up to deg. 3)
[xd,wd]=full_tensor_grid( 2, 2, @gauss_legendre_rule );
a=[1, 10, 100];
assert_equals( polyint_rule( 1, a, xd, wd ), polyint_legendre( 1, a, 2 ), 'gl_int2_1' );
a=[0,0,0,1, 10, 100];
assert_equals( polyint_rule( 2, a, xd, wd ), polyint_legendre( 2, a, 2 ), 'gl_int2_2' );
a=[0,0,0,0,0,0,1, 10, 100,1000];
assert_equals( polyint_rule( 3, a, xd, wd ), polyint_legendre( 3, a, 2 ), 'gl_int2_3' );
% test 5b: for 2 vars and 3 stage rule (integrate exactly up to deg. 5)
[xd,wd]=full_tensor_grid( 2, 3, @gauss_legendre_rule );
a=rand(1,nchoosek(2+4,2));
assert_equals( polyint_rule( 4, a, xd, wd ), polyint_legendre( 4, a, 2 ), 'gl_int2_4' );
a=rand(1,nchoosek(2+5,2));
assert_equals( polyint_rule( 5, a, xd, wd ), polyint_legendre( 5, a, 2 ), 'gl_int2_5' );
% test 5b: for 4 vars and 4 stage rule (integrate exactly up to deg. 7)
[xd,wd]=full_tensor_grid( 4, 4, @gauss_legendre_rule );
a=rand(1,nchoosek(4+7,4));
assert_equals( polyint_rule( 7, a, xd, wd ), polyint_legendre( 7, a, 4 ), 'gl_int4_4' );


% test 6: test for polynomials using gauss hermite quadrature
[xd,wd]=full_tensor_grid( 3, 3, @gauss_hermite_rule );
a=rand(1,nchoosek(3+5,3));
assert_equals( polyint_rule( 5, a, xd, wd ), polyint_gauss( 5, a, 3 ), 'gh_int3_3' );


% test 6: test for polynomials using mixed hermite/legendre quadrature
[xd,wd]=full_tensor_grid( 3, 3, {@gauss_hermite_rule, @gauss_legendre_rule, @gauss_hermite_rule} );
a=rand(1,nchoosek(3+5,3));
assert_equals( polyint_rule( 5, a, xd, wd ), polyint_mixed( 5, a, 3, [1, 3] ), 'gh_mixed_hlh' );
[xd,wd]=full_tensor_grid( 3, 3, {@gauss_legendre_rule, @gauss_hermite_rule, @gauss_legendre_rule} );
a=rand(1,nchoosek(3+5,3));
assert_equals( polyint_rule( 5, a, xd, wd ), polyint_mixed( 5, a, 3, 2 ), 'gh_mixed_lhl' );


function [x,w]=dummy_rule( p )
% DUMMY_RULE No real integration rule, but easier to verfify with.
x=linspace(-1,1,p);
w=linspace(0,1,p)';
w=w/sum(w);

function P=polyint_rule( p, a, xd, wd )
% POLYINT_RULE Integrate some polynomial using some generated rule.
Nx=size(xd,2);
m=size(xd,1);
I=multiindex( m, p );
XX=repmat( xd, [1, 1, size(I,1)] );
II=permute( repmat( I', [1, 1, Nx] ), [1 3 2] );
P=(a*permute( prod(XX.^II,1), [3,2,1]))*wd;

function P=polyint_legendre( p, a, m )
% POLYINT_LENGENDRE Integrate some polynomial on [-1,1] analytically.
P=polyint_mixed( p, a, m, [] );

function P=polyint_gauss( p, a, m )
% POLYINT_GAUSS Integrate some polynomial on [-inf,inf] with Gaussian measure analytically.
P=polyint_mixed( p, a, m, 1:m );

function P=polyint_mixed( p, a, m, gauss_vars )
% POLYINT_MIXED Integrate some polynomial with Legendre measure (x2) and Gauss measure.
I=multiindex( m, p );
i=0:max(I(:));
modes_legendre=2*uniform_raw_moments( i, -1, 1 )';
modes_gauss=normal_raw_moments( i)';
legendre_vars=1:m;
legendre_vars(gauss_vars)=[];
P=a*(prod([modes_legendre(I(:,legendre_vars)+1), modes_gauss(I(:,gauss_vars)+1)],2));

function m=uniform_raw_moments(n,a,b)
m=(a.^(n+1)-b.^(n+1))/(a-b)./(n+1);

function m=normal_raw_moments(n)
k=0:round(max(n(:))/2);
meven=round(factorial(2*k)./(2.^k.*factorial(k)));
m=zeros(size(n));
even=(mod(n,2)==0);
m(even)=meven(n(even)/2+1);
