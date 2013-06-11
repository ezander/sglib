function s=makehyperlink(text, cmd_url_file, type, varargin )
% MAKEHYPERLINK Short description of makehyperlink.
%   MAKEHYPERLINK Long description of makehyperlink.
%
% Example (<a href="matlab:run_example makehyperlink">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

protocol='';
switch type
    case {'command', 'cmd'}
        protocol='matlab:';
        href=cmd_url_file;
    case {'file'}
        protocol='error:';
        
        args=varargin;
        line=1; col=1;
        if length(args)>=1
            line=args{1};
            text=sprintf('%s at line %d', text, line );
        end
        if length(args)>=2
            col=args{2};
        end
        href=sprintf('%s,%d,%d', cmd_url_file, line, col);
    case {'url'}
        protocol='http://';
        href=cmd_url_file;
end
if isempty(strmatch( protocol, href ))
    href=[protocol, href];
end

s=sprintf( '<a href="%s">%s</a>', href, text );
