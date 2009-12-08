function ok=check_type( x, classname, emptyok, varname, mfilename, varargin )
% CHECK_TYPE Check whether input is of the specified type.
%
%   Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example (<a href="matlab:run_example check_type">run</a>)
%     x=[1;2;3];
%     A=[1, 2; 3, 4]; B=eye(2);
%     options=struct( 'mode', 'print' );
%     %pass
%     check_class( x,'double', false, 'x', mfilename, options );
%     disp( 'No warning should have appeared until now. But now they come...');
%
%     %fail
%     check_class( x,'cell', false, 'x', mfilename, options );
%
% See also CHECK_RANGE, CHECK_UNSUPPORTED_OPTIONS

%   Elmar Zander
%   Copyright 2007, 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
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
ok=ok&&(empty||isa( x, classname ));
if ~ok
    if emptyok
        emptystr='empty or ';
    else
        emptystr='';
    end
    message=sprintf( '%s must be %sof type %s but was: %s', varname, emptystr, classname, class(x) );
    check_boolean( ok, message, mfilename, 'depth', 2, 'mode', mode );
end

if nargout==0
    clear ok;
end
