function unittest_mass_matrix
%UNITTEST_MASS_MATRIX Test the MASS_MATRIX function.
%
% Example (<a href="matlab:run_example unittest_mass_matrix">run</a>)
%    unittest_mass_matrix
%
% See also MASS_MATRIX

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


munit_set_function( 'mass_matrix' );

% one element 1d
pos=[0, 1];
els=[1; 2];
assert_equals( full( mass_matrix( pos, els ) ), 1/6*[2, 1; 1, 2], 'oneelem1d' );

pos=[3, 7];
els=[1; 2];
assert_equals( full( mass_matrix( pos, els ) ), 4/6*[2, 1; 1, 2], 'oneelem1d' );

pos=[6, 3, 5, 7, 2];
els=[2; 4];
M_ex=zeros(5,5); M_ex(els,els)=4/6*[2, 1; 1, 2];
assert_equals( full( mass_matrix( pos, els ) ), M_ex, 'oneelem1d' );

% more elements 1d
[pos,els]=create_mesh_1d(0,1,11);
M=full( mass_matrix( pos, els ) );
M_ex=1/60*( diag([2 4*ones(1,9) 2])+diag(ones(1,10),1)+diag(ones(1,10),-1) );
assert_equals( sum(M(:)), 1, 'moreelem1d' );
assert_equals( M, M_ex, 'moreelem1d' );


% one element 2d
pos=[0, 0; 1, 0; 0, 1]';
els=[1; 2; 3];
assert_equals( full( mass_matrix( pos, els ) ), 1/24*[2, 1, 1; 1, 2, 1;1, 1, 2], 'oneelem2d' );

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
s=[0.00539227889849   0.00269613944925   0.00269613944925   0.00685723155134   0.00342861577567   0.00342861577567 ...
   0.00565638980573   0.00282819490287   0.00282819490287   0.00269613944925   0.07427309270518   0.01857053500204 ...
   0.01856601135055   0.03444040690334   0.00342861577567   0.01857053500204   0.06765891897822   0.01525892448707 ...
   0.03040084371344   0.00269613944925   0.01856601135055   0.06981308196797   0.01634052963343   0.03221040153474 ...
   0.00342861577567   0.01525892448707   0.04004303651405   0.00476259376996   0.01659290248135   0.00282819490287 ...
   0.00476259376996   0.01518157734565   0.00759078867282   0.01634052963343   0.04669414877625   0.02334707438813 ...
   0.00700654475469   0.00282819490287   0.03444040690334   0.03040084371344   0.03221040153474   0.01659290248135 ...
   0.00759078867282   0.02334707438813   0.15441715735138   0.00700654475469   0.00700654475469   0.00700654475469 ...
   0.01401308950938 ]';
M_ex=accumarray([i,j],s);

M=full( mass_matrix( pos, els ) );
assert_equals( M, M_ex, 'multielem2d' );


assert_error( 'mass_matrix(rand(3,4), (1:4)'')', 'simplefem:mass_matrix', 'wrong_dimen' );
