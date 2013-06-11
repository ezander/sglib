function ok=check_empty( x, varname, mfilename, varargin )
% CHECK_EMPTY Checks that some variable is empty.
%   OK=CHECK_EMPTY( X, VARNAME, MFILENAME ) checks that X is empty and
%   raises an error otherwise. This is useful, when certain options make
%   sense only in certain situations (i.e. with certain other parameters)
%   and not otherwise. Then, to avoid confusion to the user, because the
%   value of X is ignored, this check can be made.
%
% Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example (<a href="matlab:run_example check_empty">run</a>)
%     % inside some function 
%     %    function xyz( use_val, options )
%     % suppose the actual arguments were like:
%     use_val=false;
%     options.val='some val';
% 
%     % parsing the options...
%     val=get_option( options, 'val',  {} );
% 
%     % now the function body 
%     if use_val
%        % do some thing with val, i.e. val is really needed here
%        disp(val);
%     else
%        % val is not needed here, so when the user has still passed
%        % it as an option issue a warning
%        fprintf( 'If val is not empty an error message will be produced next\n' );
%        check_empty( val, 'val', mfilename, 'mode', 'warning' );
%     end
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

ok=isempty(x);
if ~ok
    message=sprintf( '''%s'' is not empty as it should be (maybe ''%s'' is an option that doesn''t make sense here?)', varname, varname );
    check_boolean( ok, message, mfilename, 'depth', 2, 'mode', mode );
end

if nargout==0
    clear ok;
end
