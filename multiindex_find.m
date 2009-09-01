function ind=multiindex_find( I_r, alpha )
% MULTIINDEX_FIND Find a multiindex in a list of indices.
%   IND=MULTIINDEX_FIND( I_R, ALPHA ) tries to find the multiindex ALPHA in
%   the list of multiindices given by I_R. Returned are the indices in I_R
%   where ALPHA was found (not a logical array as in a previous version of
%   this function). ALPHA may also contain more than one multiindex to
%   find, e.g. you may use MULTIINDEX_FIND( I_U, I_F ) to find the indices
%   of of all multiindices of I_F within I_U.
%
% Example (<a href="matlab:run_example multiindex_find">run</a>)
%   I=multiindex(5,3);
%   alpha=[0 0 0 0 0; 0 1 0 0 2]; disp('indices to find:'); disp(alpha);
%   ind=multiindex_find( I, alpha );
%   disp('found at:'); disp(ind);
%   disp('check correctness:'); disp(I(ind,:));
%
% See also MULTIINDEX, ISMEMBER

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

[dummy,ind]=ismember(alpha, I_r, 'rows'); 
dummy; %#ok
