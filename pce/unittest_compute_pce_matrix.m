function unittest_compute_pce_matrix
% UNITTEST_COMPUTE_PCE_MATRIX Test the compute_pce_matrix function.
%
% Example (<a href="matlab:run_example unittest_compute_pce_matrix">run</a>)
%   unittest_compute_pce_matrix;
%
% See also COMPUTE_PCE_MATRIX, MUNIT_RUN_TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% test 1: single k_iota
I_u=multiindex(3,2);
I_k=multiindex(3,3);
% using large enough primes for the k_iota vector chances are low we get
% the right result only by coincidence
p=primes(300); p=p(29:end);
k_iota=p(1:size(I_k,1));
Delta = [
         109         113         127         131         274         139         298         151         157         326
         113         383         139         151        1228         473         358         513         193         398
         127         139         407         157         346         471        1340         193         525         422
         131         151         157         435         382         193         394         511         549        1600
         274        1228         346         382        1314         278           0         302           0           0
         139         473         471         193         278         681         278         157         151           0
         298         358        1340         394           0         278        1410           0         314           0
         151         513         193         511         302         157           0         709         139         302
         157         193         525         549           0         151         314         139         733         314
         326         398         422        1600           0           0           0         302         314        1522
         ];
assert_equals( compute_pce_matrix( k_iota, I_k, I_u ), Delta, 'prime' );

% test 2: multiple k_iota
I_u=multiindex(2,2);
I_k=multiindex(2,2);
p=primes(300); 
M_k=size(I_k,1);
k_i_iota=reshape(p(1:3*M_k),3,M_k);
Delta=zeros(6,6,3);
Delta(:,:,1) =[
     2     7    17    58    41   106
     7    60    41    14    17     0
    17    41   108     0     7    34
    58    14     0   236    82     0
    41    17     7    82   166    82
   106     0    34     0    82   428];
Delta(:,:,2) =[
     3    11    19    62    43   118
    11    65    43    22    19     0
    19    43   121     0    11    38
    62    22     0   254    86     0
    43    19    11    86   183    86
   118     0    38     0    86   478];
Delta(:,:,3) =[
     5    13    23    74    47   122
    13    79    47    26    23     0
    23    47   127     0    13    46
    74    26     0   306    94     0
    47    23    13    94   201    94
   122     0    46     0    94   498];
assert_equals( compute_pce_matrix( k_i_iota, I_k, I_u ), Delta, 'multi' );

assert_equals( compute_pce_matrix( k_i_iota, I_k, I_u, 'algorithm', 1 ), Delta, 'multi' );
assert_equals( compute_pce_matrix( k_i_iota, I_k, I_u, 'algorithm', 2 ), Delta, 'multi' );
assert_equals( compute_pce_matrix( k_i_iota, I_k, I_u, 'algorithm', 3 ), Delta, 'multi' );

DeltaMat = reshape(Delta, [], size(Delta,3));
assert_equals( compute_pce_matrix( k_i_iota, I_k, I_u, 'algorithm', 4 ), DeltaMat, 'multi' );
