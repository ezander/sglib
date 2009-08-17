function str=underline( s, varargin )
% UNDERLINE Underlines and outputs a given text.
%   STR=UNDERLINE( S, OPTIONS ) underlines S with a line of equals signs
%   (=) the length of S and returns it as STR.
%
%   UNDERLINE( S, OPTIONS ) displays the underlined strings via DISP.
%
% Options:
%   char: '='
%     The character used for underlining the string.
%
% Example (<a href="matlab:run_example underline">run</a>)
%   M=rand(2);
%   underline( 'Here comes a random matrix' );
%   disp(M);
%
% See also DISP, DOC_OPTIONS

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
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
[uchar,options]=get_option( options, 'char', '=' );
check_unsupported_options( options, mfilename );

n=length(s);
s=sprintf( '%s\n%s', s, repmat( uchar, 1, n ) );
if nargout==0
    disp( s )
else
    str=s;
end
