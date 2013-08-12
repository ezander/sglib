function C=binfun(func, A, B, varargin)
% BINFUN Computes a binary function with singleton dimensions expanded.
%   C=BINFUN(FUNC, A, B) computes the same as BSXFUN, however, BINFUN works
%   for Matlab versions before 7.4. If the matlab version if 7.4 or later,
%   the FUNC is not a cell array, and the option 'avoid_bsxfun' is not
%   specified, the matlab function BSXFUN is used for greater efficiency.
%
% Example (<a href="matlab:run_example binfun">run</a>)
%   % compute power of some primes to the first few natural numbers
%   binfun(@power, [2;3;5], [0,1,2,3])
%
%   % subtract mean from random array
%   A = rand(5, 6);
%   A = binfun(@minus, A, mean(A,2))
%
% See also BSXFUN

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

options=varargin2options(varargin);
[avoid_bsxfun, options]=get_option(options, 'avoid_bsxfun', false);
check_unsupported_options(options, mfilename);

if avoid_bsxfun || iscell(func) || isversion('0.0', '7.4')
    n=max(ndims(A),ndims(B));
    sa=size(A);
    sb=size(B);
    sa=[sa ones(1,n-length(sa))];
    sb=[sb ones(1,n-length(sb))];
    if ~all(sa==sb | sa==1 | sb==1)
        error('MATLAB:bsxfun:arrayDimensionsMustMatch', 'Non-singleton dimensions of the two input arrays must match each other.');
    end
    oa=sa==1;
    ob=sb==1;
    ra=ones(1,n);
    rb=ones(1,n);
    rb(ob)=sa(ob);
    ra(oa)=sb(oa);
    C=funcall( func, repmat( A, ra ), repmat( B, rb ) );
else
    C=bsxfun(func, A, B);
end
