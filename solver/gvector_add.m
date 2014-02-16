function T=gvector_add( T1, T2, alpha )
% GVECTOR_ADD Add two vectors.
%   GVECTOR_ADD( T1, T2, ALPHA ) adds two vectors T1 and T2,
%   multiplying T2 by ALPHA first if given.
%
% Note 1: implementation is of course trivial, since addition of sparse
%   vectors if simply juxtaposition, but having this as a separate function
%   makes the code clearer.
%
% Note 2: This method does not perform reduction of the new vector. You
%   have to call GVECTOR_REDUCE manually to achieve this.
%
% Example (<a href="matlab:run_example gvector_add">run</a>)
%   T1={rand(8,2), rand(10,2)}
%   T2={rand(8,3), rand(10,3)}
%   Z=gvector_add(T1,T2,3)
%   norm( T1{1}*T1{2}'+3*T2{1}*T2{2}'-Z{1}*Z{2}', 'fro' )% should be approx. zero
%
% See also GVECTOR_REDUCE, GVECTOR_NULL, GVECTOR_SCALE

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
    error( 'vector:gvector_null:param_error', ...
        'input parameter is no recognized vector format or formats don''t match' );
end
