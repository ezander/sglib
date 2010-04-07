function multiplot_legend(mh,i,j,c,varargin)
% MULTIPLOT_LEGEND Short description of multiplot_legend.
%   MULTIPLOT_LEGEND Long description of multiplot_legend.
%
% Example (<a href="matlab:run_example multiplot_legend">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[format,options]=get_option(options,'format','%g');
[paramname,options]=get_option(options,'paramname','');
check_unsupported_options(options,mfilename);

if ~isempty(paramname)
    format=[paramname, '=', format];
end

if isnumeric(c)
    c=cellfun( @(x)(sprintf(format,x) ), num2cell( c ), 'UniformOutput', false );
end

multiplot( mh, i, j );
legend(c);
