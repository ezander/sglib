function cells=merge_cells( cells1, pos1, cells2 )
% MERGE_CELLS Merges two cell arrays with specified positions.
%   CELLS=MERGE_CELLS( CELLS1, POS1, CELLS2 ) merges the cell arrays
%   specified in CELLS1 and CELLS2 into a single cell array CELLS where the
%   the elements of CELLS1 are placed at the positions in POS1 and the
%   elements of CELLS2 are filled in from left to right.
%
% Example (<a href="matlab:run_example merge_cells">run</a>)
%   merge_cells( {'a','b'}, {2,4}, {'c','d','e'} );
%   % returns {'c', 'a', 'd', 'b', 'e' }
%
% See also CELL

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


n=length(cells1)+length(cells2);
cells=cell( 1,n );

inds1=zeros(1,n);
if length(pos1)>1
    pos1=horzcat(pos1{:});
elseif length(pos1)==1
    pos1=pos1{1};
else
    pos1=[];
end
inds1(pos1)=1;
inds1=logical(inds1);
inds2=~inds1;

cells(pos1)=cells1;
cells(inds2)=cells2;

