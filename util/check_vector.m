function ok=check_vector( x, emptyok, varname, filename, varargin )
% CHECK_VECTOR Check whether input is a vector.
%
% Example (<a href="matlab:run_example check_condition">run</a>)
%     x=[1;2;3];
%     A=[1, 2; 3, 4]; B=eye(2);
%     options=struct( 'mode', 'print' );
%     %pass
%     check_vector( x, false, 'x', mfilename, options );
%     check_vector( [], true, '?', mfilename, options );
%     disp( 'No warning should have appeared until now. But now they come...');
%
%     %fail
%     check_vector( A, true, 'A', mfilename, options );
%     check_vector( [], false, '?', mfilename, options );
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
ok=ok&&(empty||isvector( x ));

if ~ok
    if emptyok
        emptystr='empty or ';
    else
        emptystr='';
    end
    message=sprintf( '%s must be %sa vector', varname, emptystr );
    check_boolean( ok, message, filename, 'depth', 2, 'mode', mode );
end

if nargout==0
    clear ok;
end
