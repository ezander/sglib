function ok=check_match( x1, x2, emptyok, varname1, varname2, mfilename, varargin )
% CHECK_MATCH Check whether input matrices are compatible.
%
%   Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example (<a href="matlab:run_example check_match">run</a>)
%     x=[1;2;3];
%     A=[1, 2; 3, 4]; B=eye(2);
%     options=struct( 'mode', 'print' );
%     %pass
%     check_match( A, B, false, 'A', 'B', mfilename, options );
%     check_match( A, [], true, 'A', '?', mfilename, options );
%     disp( 'No warning should have appeared until now. But now they come...');
%     %fail
%     check_match( A, x, false, 'A', 'x', mfilename, options );
%     check_match( A, [], false, 'A', '?', mfilename, options );
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

% we interpret empty here a bit differently, namely that ALL
% dimensions are 0 (that what you get from []). A Nx0 matrix is
% also reported as empty by matlab (which makes sense), but still
% can be checked for compatibility).
empty=max(size(x1))==0||max(size(x2))==0;
ok=true;
ok=ok&&(emptyok||~empty);
if ~empty
    sz1=operator_size( x1 );
    sz2=operator_size( x2 );
    ok=ok&&(sz1(2)==sz2(1));
end
if ~ok
    s1=strtrim(evalc('disp({x1})'));
    s2=strtrim(evalc('disp({x2})'));
    message=sprintf( 'inner dimensions of %s and %s don'' match: %s ~ %s', varname1, varname2, s1, s2 );
    check_boolean( ok, message, mfilename, 'depth', 2, 'mode', mode );
end

if nargout==0
    clear ok;
end
