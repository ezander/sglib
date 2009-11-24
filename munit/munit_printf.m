function munit_printf(type, message, vars)
% MUNIT_PRINTF Short description of munit_printf.
%   MUNIT_PRINTF Long description of munit_printf.
%
% Example (<a href="matlab:run_example munit_printf">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

%options=munit_options();
switch type
    case 'debug'
        no_disp=true;
    otherwise
        no_disp=false;
end

if ~no_disp
    fprintf( message, vars{:} );
end
