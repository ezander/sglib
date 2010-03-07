function unittest_tensor_truncate_svd
% UNITTEST_TENSOR_TRUNCATE_SVD Test the TENSOR_TRUNCATE_SVD function.
%
% Example (<a href="matlab:run_example unittest_tensor_truncate_svd">run</a>)
%   unittest_tensor_truncate_svd
%
% See also TENSOR_TRUNCATE_SVD, TESTSUITE 

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

munit_set_function( 'tensor_truncate_svd' );

N=110;
M=80;
L=60;

T={rand(N,L), rand(M,L)};
eps=0.001;
k_max=inf;
relcutoff=true;
p=2;
[T_k,sigma,k]=tensor_truncate_svd( T, {[],[]}, eps, k_max, relcutoff, p );
[ sigma tensor_modes( T )]
1;


