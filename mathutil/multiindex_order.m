function order=multiindex_order( pci )
% MULTIINDEX_ORDER Compute the order of a multiindex.
%   FACT=MULTIINDEX_ORDER( PCI ) computes the order of the multiindex given
%   in PCI. PCI has to be a row vector. If there are multiple rows the
%   order of each row is calculated, i.e. fact(i) is the order of pci(i,:).
%
% Example (<a href="matlab:run_example multiindex_order">run</a>)
%   % Generate the polynomial chaos for 2 random variables up to
%   % polynomial order 4
%   A=multiindex(2,4);
%   % Show the factorials of the generated polynomial chaoses
%   disp( multiindex_order(pci) );
%
% See also MULTIINDEX, MULTIINDEX_FACTORIAL

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


order=full(sum(pci,2));
