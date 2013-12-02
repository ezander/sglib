function unittest_stiffness_matrix
%UNITTEST_STIFFNESS_MATRIX Test the STIFFNESS_MATRIX function.
%
% Example (<a href="matlab:run_example unittest_stiffness">run</a>)
%    unittest_stiffness
%
% See also STIFFNESS_MATRIX

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'stiffness_matrix' );

% one element 1d
pos=[0,1];
els=[1; 2];
assert_equals( full( stiffness_matrix( pos, els ) ), [1 -1; -1 1], 'oneelem1d' );

pos=[3, 7];
els=[1; 2];
assert_equals( full( stiffness_matrix( pos, els ) ), 1/4*[1 -1; -1 1], 'oneelem1d' );

pos=[6, 3, 5, 7, 2];
els=[2; 4];
M_ex=zeros(5,5); M_ex(els,els)=1/4*[1 -1; -1 1];
assert_equals( full( stiffness_matrix( pos, els ) ), M_ex, 'oneelem1d' );

% more elements 1d
[pos,els]=create_mesh_1d(0,1,11);
K=full( stiffness_matrix( pos, els ) );
K_ex=10*( diag([1 2*ones(1,9) 1])-diag(ones(1,10),1)-diag(ones(1,10),-1) );
assert_equals( sum(K(:)), 0, 'moreelem1d' );
assert_equals( K, K_ex, 'moreelem1d' );

% one element 2d
pos=[0 0; 1 0; 0 1]';
els=[1; 2; 3];
assert_equals( full( stiffness_matrix( pos, els ) ), 1/2*[2 -1 -1; -1 1 0;-1 0 1], 'oneelem2d' );

% multi element 2d
 pos=[
                  0                  0
                  0   1.00000000000000
   1.00000000000000   1.00000000000000
  -0.00000000029014   0.25820422653147
  -0.00000000024494   0.70389706208105
   0.25060529663331   0.00000000005262
   0.27789923056637   1.00000000203634
   0.73095790035381   1.00000000162831
   0.77510383423028  -0.00000000000212
   1.00000000985480   0.74770982772568
   1.00000000102578   0.00000000008107
    ]';
els=[
     6     9    10
     4    10     5
     4     6    10
    10     7     5
     3     8    10
     8     7    10
     4     1     6
     7     2     5
     9    11    10
     ]';

i=[  1     4     6     2     5     7     3     8    10     1     4     5     6    10     2     4     5     7    10     1 ...
     4     6     9    10     2     5     7     8    10     3     7     8    10     6     9    10    11     3     4     5 ...
     6     7     8     9    10    11     9    10    11 ]';
j=[ 1     1     1     2     2     2     3     3     3     4     4     4     4     4     5     5     5     5     5     6 ...
     6     6     6     6     7     7     7     7     7     8     8     8     8     9     9     9     9    10    10    10 ...
    10    10    10    10    10    10    11    11    11 ]';

s=[1.00044619240874  -0.48528504013218  -0.51516115227656   1.00201354524399  -0.46926118824445  -0.53275235699954 ...
   1.00206722842539  -0.46886748345996  -0.53319974496543  -0.48528504013218   3.08044818942872  -1.14590870959390 ...
  -1.46425629137446   0.01500185167182  -0.46926118824445  -1.14590870959390   2.89025623636721  -1.25216381240688 ...
  -0.02292252612199  -0.51516115227656  -1.46425629137446   2.91974929204480  -0.92766014907777  -0.01267169931601 ...
  -0.53275235699954  -1.25216381240688   2.89220885461903  -1.12826233867649   0.02096965346388  -0.46886748345996 ...
  -1.12826233867649   3.02822156395382  -1.43109174181738  -0.92766014907777   3.09113138148002  -0.50112669128050 ...
  -1.66234454112176  -0.53319974496543   0.01500185167182  -0.02292252612199  -0.01267169931601   0.02096965346388 ...
  -1.43109174181738  -0.50112669128050   2.61543090768886  -0.15039000932325  -1.66234454112176  -0.15039000932325 ...
   1.81273455044501 ];
K_ex=accumarray( [i,j], s );

K=full( stiffness_matrix( pos, els ) );
assert_equals( K, K_ex, 'multielem2d' );

assert_error( 'stiffness_matrix(rand(3,4), (1:4)'' )', 'simplefem:stiffness', 'wrong_dimen' );
