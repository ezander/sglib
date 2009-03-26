function ok=check_condition( x, varcond, emptyok, varname, mfilename )
% CHECK_CONDITION Check whether specified condition holds for input parameter.
%   OK=CHECK_CONDITION( COND, MESSAGE, MFILENAME ) checks whether the given condition 
%   is true. If not an error message is printed and the program is aborted.
%
%   Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example
%   function my_function( str )
%
%     check_condition( strcmp(str,str(end:-1:1)), 'str must be a palindrome', mfilename );
%
% See also CHECK_RANGE, CHECK_UNSUPPORTED_OPTIONS

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if ~exist('mfilename','var') || isempty(mfilename)
    mfilename='global';
end

if emptyok
    emptystr='empty or ';
else
    emptystr='';
end

ok=true;
switch varcond
    case {'vector', 'isvector'}
        empty=isempty(x);
        ok=ok&&(emptyok||~empty);
        ok=ok&&(empty||isvector( x ));
        if ~ok
            message=sprintf( '%s must be %sa vector', varname, emptystr );
        end
    case {'scalar', 'isscalar'}
        empty=isempty(x);
        ok=ok&&(emptyok||~empty);
        ok=ok&&(empty||isscalar( x ));
        if ~ok
            message=sprintf( '%s must be %sa scalar', varname, emptystr );
        end
    case {'square', 'issquare' }
        empty=isempty(x);
        ok=ok&&(emptyok||~empty);
        ok=ok&&(empty||size(x,1)==size(x,2));
        if ~ok
            s1=strtrim(evalc('disp({x})'));
            message=sprintf( '%s must be %sa square matrix: %s', varname, emptystr, s1);
        end
    case {'function', 'isfunction'}
        empty=isempty(x);
        ok=ok&&(emptyok||~empty);
        ok=ok&&(empty||isfunction( x ));
        if ~ok
            message=sprintf( '%s must be %sa function type', varname, emptystr );
        end
    case 'match'
        empty=isempty(x{1})||isempty(x{2});
        ok=ok&&(emptyok||~empty);
        ok=ok&&(empty|| size(x{1},2)==size(x{2},1));
        if ~ok
            s1=strtrim(evalc('disp({x{1}})'));
            s2=strtrim(evalc('disp({x{2}})'));
            message=sprintf( 'inner dimensions of %s and %s don'' match: %s ~ %s', varname{1}, varname{2}, s1, s2 );
        end
    case {'class', 'isa'}
        empty=isempty(x{1})||isempty(x{2});
        ok=ok&&(emptyok||~empty);
        ok=ok&&(empty||isa( x{1}, x{2} ));
        if ~ok
            message=sprintf( '%s must be %sof type %s: %s', varname, emptystr, x{2}, class(x{1}) );
        end
    otherwise
        error([mfilename ':condition'], sprintf( '%s: unknown condition to check: %s', mfilename, varcond ) );
end


if ~ok
    error([mfilename ':condition'], sprintf( '%s: %s', mfilename, message ) );
end
