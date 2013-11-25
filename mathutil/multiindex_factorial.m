function fact=multiindex_factorial( pci )
% MULTIINDEX_FACTORIAL Compute the factorial of a multiindex.
%   FACT=MULTIINDEX_FACTORIAL( PCI ) computes the factorial of the
%   multiindex given in PCI. PCI has to be a row vector. If there are
%   multiple rows the factorial of each row is calculated, i.e. fact(i) is
%   the multiindex-factorial of pci(i,:).
%
% Example (<a href="matlab:run_example multiindex_factorial">run</a>)
%   % Generate the polynomial chaos for 2 random variables up to
%   % polynomial order 4
%   I=multiindex(2,4);
%   % Show the factorials of the generated polynomial chaoses
%   f=multiindex_factorial(I);
%   disp([I,f]);
%
% See also MULTIINDEX, MULTIINDEX_ORDER

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


fact=prod(factorial(full(pci)),2);
%fact=prod(reshape(factorial(full(pci)),size(pci)),2);
