function C=binfun( func, A, B )
% BINFUN Computes a binary function with singleton dimensions expanded.
%   BINFUN Long description of binfun.
%
% Example (<a href="matlab:run_example binfun">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

n=max(ndims(A),ndims(B));
sa=size(A);
sb=size(B);
sa=[sa ones(1,n-length(sa))];
sb=[sb ones(1,n-length(sb))];
oa=sa==1;
ob=sb==1;
ra=ones(1,n);
rb=ones(1,n);
rb(ob)=sa(ob);
ra(oa)=sb(oa);
C=funcall( func, repmat( A, ra ), repmat( B, rb ) );
