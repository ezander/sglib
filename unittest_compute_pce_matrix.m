% UNITTEST_COMPUTE_PCE_MATRIX Test the compute_pce_matrix function.
%
% Example (<a href="matlab:run_example unittest_compute_pce_matrix">run</a>)
%   unittest_compute_pce_matrix;
%
% See also COMPUTE_PCE_MATRIX, TESTSUITE

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.



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


if 0
    % this section is for testing speed only
    % don't include in normal test runs
    hermite_triple_fast(10);
    I_k=multiindex(4,4);
    I_f=multiindex(2,3);
    [I_k,I_f,I_u]=multiindex_combine( {I_k, I_f}, -1 );
    n=10;
    k_iota=rand(n,size(I_k,1));
    tic;
    Delta=compute_pce_matrix( k_iota, I_k, I_u );
    toc
end
