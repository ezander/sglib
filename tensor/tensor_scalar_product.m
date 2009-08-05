function d=tensor_scalar_product( T1, T2, varargin )
% TENSOR_SCALAR_PRODUCT Compute the scalar product of two sparse tensors.
%   D=TENSOR_SCALAR_PRODUCT( T1, T2 ) computes the scalar product of the 
%   two sparse tensors T1 and T2. In the form D=TENSOR_SCALAR_PRODUCT( T1,
%   T2, M1, M2 ) the scalar product is taken with respect to the "mass"
%   matrices or Gramians M1 and M2.
%
% Example (<a href="matlab:run_example tensor_scalar_product">run</a>)
%
% See also TENSOR_NORM

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin{:} );
[M1,options]=get_option( options, 'M1', [] );
[M2,options]=get_option( options, 'M2', [] );
check_unsupported_options( options, mfilename );

S1=inner( T1{1}, T2{1}, M1 ); 
S2=inner( T1{2}, T2{2}, M2 ); 
s=S1.*S2;
d=-1i*sum(sort(1i*s(:))); % sum in order of ascending magnitude

function S=inner( A, B, M )
if ~isempty(M) 
    S=A'*M*B;
else
    S=A'*B;
end

