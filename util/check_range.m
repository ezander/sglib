function ok=check_range( x, lo, hi, varname, mfilename )
% CHECK_RANGE Check whether input argument is scalar and in range.
%   OK=CHECK_RANGE( X, LO, HI, VARNAME, MFILENAME ) checks whether input
%   parameter X is scalar and if it is, whether it is in the range [LO,HI]
%   (inclusive bounds). VARNAME and MFILENAME are strings used for printing
%   sensible error messages. 
%
%   Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example (<a href="matlab:run_example check_range">run</a>)
%   function my_function( num )
%
%     check_range( num, 1, 5, 'num', mfilename );
%
% See also CHECK_CONDITION, CHECK_UNSUPPORTED_OPTIONS

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


if ~exist('mfilename','var') || isempty(mfilename)
	mfilename='global';
end

if ~isscalar(x)
    s=strtrim(evalc('disp({x})'));
    error([mfilename ':range'], '%s: input argument "%s" is not scalar: %s', mfilename, varname, s )
elseif x<lo || x>hi
    error([mfilename ':range'], '%s: input argument "%s" not in range [%g,%g]: %g', mfilename, varname, lo, hi, x )
end
