function d=multiindex_size(m,p)
% MULTIINDEX_SIZE Return the size of a multiindex set.
%   MULTIINDEX_SIZE(M,P) returns the size of the multiindex set for
%   multindices in M independents up to order P.
%
% Example (<a href="matlab:run_example multiindex_size">run</a>)
%   disp( multiindex_size( 3, 5) );
%   disp( size( multiindex(3,5), 1) ); % should give the same
%
% See also MULTIINDEX

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

d=nchoosek(m+p,p);
