function T=ctensor_add( T1, T2, alpha )
% CTENSOR_ADD Add two canonical tensors.
%   CTENSOR_ADD( T1, T2, ALPHA ) adds two tensors T1 and T2 in canonical
%   format, multiplying T2 by ALPHA first if given. If ALPHA is unspecified
%   or empty the tensor are just added.
%
% Note 1: implementation is of course trivial, since addition of tensors if
%   simply juxtaposition, but having this as a separate function makes the
%   code clearer. 
%
% Note 2: This method does not perform reduction of the new tensor. You
%   have to call TENSOR_TRUNCATE manually to achieve this.
%
% Example (<a href="matlab:run_example ctensor_add">run</a>)
%   T1={rand(8,2), rand(10,2)}
%   T2={rand(8,3), rand(10,3)}
%   Z=ctensor_add(T1,T2,3)
%   norm( T1{1}*T1{2}'+3*T2{1}*T2{2}'-Z{1}*Z{2}', 'fro' )% should be approx. zero
%
% See also TENSOR_TRUNCATE, CTENSOR_NULL, CTENSOR_SCALE

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

check_tensors_compatible( T1, T2 );

% We do a rank check here, because usually if the rank is growing too large
% that hints at a bug in the code (forgotten tensor truncations), and
% before crashing the computer, the user is given a hint.
persistent max_rank;
if isempty(max_rank)
    max_rank=10000;
end

if ctensor_rank(T1)+ctensor_rank(T2)>max_rank
    warning( 'tensor:ctensor_add:large', ['Your tensor is growing pretty large. Forgotten to truncate?\n', ... 
        'max_size is currently %d. You may set it to a higher value by entering e.g. max_size=%d.'], ...
        max_rank, 10*max_rank );
    keyboard;
end
    

% Important: apply multiplication with alpha only to one component, since
% this is a tensor (not a Cartesian product or something).
if alpha~=1
    T2{1}=alpha*T2{1};
end

D = ctensor_order(T1);
T=cell(1,D);
for d = 1:D
    T{d} = [T1{d}, T2{d}];
end
