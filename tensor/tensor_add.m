function T=tensor_add( T1, T2, alpha )
% TENSOR_ADD Add two tensors.
%   T=TENSOR_ADD( T1, T2 ) adds two tensors T1 and T2 and returns the
%   result in T.
%   T=TENSOR_ADD( T1, T2, ALPHA ) adds two tensors T1 and T2, multiplying
%   T2 by ALPHA first if given.
%
% Note: This method does not perform truncation/approximation of the new
%   tensor. You have to call a suitable tensor approximation/truncation
%   function manually to do this.
%
% Example (<a href="matlab:run_example tensor_add">run</a>)
%   T1={rand(8,2), rand(10,2)}
%   T2={rand(8,3), rand(10,3)}
%   Z=tensor_add(T1,T2,3)
%   norm( T1{1}*T1{2}'+3*T2{1}*T2{2}'-Z{1}*Z{2}', 'fro' )% should be approx. zero
%
% See also TENSOR_NULL, TENSOR_SCALE

%   Elmar Zander
%   Copyright 2007-2014, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if nargin<3
    alpha=1;
end

if isnumeric(T1) && isnumeric(T2)
    T=T1+alpha*T2;
elseif is_ctensor(T1) && is_ctensor(T2)
    T=ctensor_add( T1, T2, alpha );
elseif isobject(T1)
    T=T1+alpha*T2;
else
    error( 'sglib:tensor_null:param_error', ...
        'input parameter is no recognized tensor format or formats don''t match' );
end
