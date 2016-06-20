function ok=check_one_of( x, values, varname, mfilename, varargin )
% CHECK_ONE_OF Check whether input argument is one of the given values.
%   CHECK_ONE_OF(VARARGIN) Long description of check_one_of.
%
% Example (<a href="matlab:run_example check_one_of">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2016, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin );
[mode,options]=get_option( options, 'mode', 'debug' );
check_unsupported_options( options, mfilename );

if ~exist('mfilename','var') || isempty(mfilename)
	mfilename='global';
end

ok=false;
for i=1:numel(values)
    if isequal(values{i}, x)
        ok=true;
        break;
    end
end

if ~ok
    message=strvarexpand( 'input argument "$varname$" was "$x$", not an element of $values$' );
    check_boolean( ok, message, mfilename, 'depth', 2, 'mode', mode );
end

if nargout==0
    clear ok;
end
