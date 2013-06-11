function s=datestring(varargin)
% DATESTRING Short description of datestring.
%   DATESTRING Long description of datestring.
%
% Example (<a href="matlab:run_example datestring">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[separator,options]=get_option(options,'separator','-');
[inctime,options]=get_option(options,'inctime',true);
[incsecs,options]=get_option(options,'incsecs',true);
[the_date,options]=get_option(options,'date',clock);
check_unsupported_options(options,mfilename);

format='%4d-%02d-%02d'; num=3;
if inctime
    format=[format '-%02d%02d']; num=num+2;
    if incsecs
        format=[format '%02.0f']; num=num+1;
    end
end

s = sprintf( format, the_date(1:num));
s=strrep( s, '-', separator );
