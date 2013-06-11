function ok=check_function( x, emptyok, varname, mfilename, varargin )
% CHECK_FUNCTION Check whether input is callable.
%
%   Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example (<a href="matlab:run_example check_function">run</a>)
%     options=struct( 'mode', 'print' );
%     %pass
%     check_function( @disp, false, '@cf', mfilename, options );
%     disp( 'No warning should have appeared until now. But now they come...');
%
%     %fail
%     check_function( 1, false, 'xyz1', mfilename, options );
%
% See also CHECK_RANGE, CHECK_UNSUPPORTED_OPTIONS

%   Elmar Zander
%   Copyright 2007, 2009, Institute of Scientific Computing, TU Braunschweig.
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

empty=isempty(x);
ok=true;
ok=ok&&(emptyok||~empty);
ok=ok&&(empty||isfunction( x ));
if ~ok
    if emptyok
        emptystr='empty or ';
    else
        emptystr='';
    end
    message=sprintf( '%s must be %sa function type, but was: %s', varname, emptystr, class(x) );
    check_boolean( ok, message, mfilename, 'depth', 2, 'mode', mode );
end

if nargout==0
    clear ok;
end
