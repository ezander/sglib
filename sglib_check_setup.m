function sglib_check_setup
% SGLIB_CHECK_SETUP Checks whether SGLIB was setup correctly.
%   SGLIB_CHECK_SETUP checks for the existence of APPDATA for 'sglib',
%   indicating correct initialization of SGLIB.
%
% Example (<a href="matlab:run_example sglib_check_setup">run</a>)
%   sglib_check_setup
%
% See also SGLIB_STARTUP, ISAPPDATA

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

if ~isappdata( 0, 'sglib' )
    error( 'SGLIB:not_initialized', 'SGLIB wasn''t initialized correctly.\nPlease run SGLIB_STARTUP manually.' );
end
