function ok=check_condition( cond, message, mfilename )
% CHECK_CONDITION Check whether condition is true on input.
%   OK=CHECK_CONDITION( COND, MESSAGE, MFILENAME ) checks whether the given condition 
%   is true. If not an error message is printed and the program is aborted.
%
%   Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example
%   function my_function( str )
%
%     check_condition( strcmp(str,str(end:-1:1)), 'str must be a palindrome', mfilename );
%
% See also CHECK_RANGE, CHECK_UNSUPPORTED_OPTIONS

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


if ~cond
    if ~exist('mfilename','var') || isempty(mfilename)
        mfilename='global';
    end
    error([mfilename ':condition'], message )
end
    
    

