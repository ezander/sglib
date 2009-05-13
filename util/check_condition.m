function ok=check_condition( x, varcond, emptyok, varname, mfilename, varargin )
% CHECK_CONDITION Check whether specified condition holds for input parameter(s).
%   OK=CHECK_CONDITION( X, VARCOND, EMPTYOK, VARNAME, MFILENAME ) checks
%   whether the given condition is true. If not an error message is printed
%   and the program is aborted. Depending on VARCOND (which specifies which
%   condition to check), X can contain 1 or 2 values of expressions or
%   variables (in the second case a cell array must be passed), and VARNAME
%   must contain the names equivalently (i.e. a cell array if two names are
%   passed). Possibilities for VARCOND are:
%     'vector', 'isvector': is X a vector?
%     'scalar', 'isscalar': is X a scalar?
%     'square', 'issquare': is X a square matrix?
%     'function', 'isfunction': is X a function?
%     'match': can X{1} be (matrix-) multiplied with X{2}?
%     'class', 'isa': is X{1} of type X{2}?
%   If EMPTYOK is true, the variable may also be empty to pass the test.
%
%   Note: pass mfilename literally for the last argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example (<a href="matlab:run_example check_condition">run</a>)
%     x=[1;2;3];
%     A=[1, 2; 3, 4]; B=eye(2);
%     options.warnonly=true;
%     %pass
%     check_condition( x, 'vector', false, 'x', mfilename, options );
%     check_condition( [], 'vector', true, '?', mfilename, options );
%     check_condition( 1, 'scalar', true, '1', mfilename, options );
%     check_condition( A, 'square', true, 'A', mfilename, options );
%     check_condition( @check_condition, 'function', false, '@cf', mfilename, options );
%     check_condition( {A,B}, 'match', false, {'A','B'}, mfilename, options );
%     check_condition( {A,[]}, 'match', true, {'A','?'}, mfilename, options );
%     check_condition( {x,'double'}, 'match', false, x, mfilename, options );
%
%     %fail
%     check_condition( A, 'vector', true, 'A', mfilename, options );
%     check_condition( [], 'vector', false, '?', mfilename, options );
%     check_condition( A, 'scalar', true, 'A', mfilename, options );
%     check_condition( x, 'square', true, 'x', mfilename, options );
%     check_condition( 1, 'function', false, '1', mfilename, options );
%     check_condition( {A,x}, 'match', false, {'A','x'}, mfilename, options );
%     check_condition( {A,[]}, 'match', false, {'A','?'}, mfilename, options );
%     check_condition( {x,'cell'}, 'isa', false, 'x', mfilename, options );
%



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

options=varargin2options( varargin{:} );
[warnonly,options]=get_option( options, 'warnonly', false );
check_unsupported_options( options, mfilename );


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
        if ~empty
            sz1=apply_linear_operator( x{1} );
            sz2=apply_linear_operator( x{2} );
            ok=ok&&(sz1(2)==sz2(1));
        end
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
    if ~warnonly
        %error([mfilename ':condition'], sprintf( '%s: %s', mfilename, message ) );
        
        %stack=struct2cell( dbstack('-completenames') );
        %caller=stack(2);
        
        fprintf( '\nCheck failed in: %s\n%s\n', mfilename, message );
        cmd=repmat( 'dbup;', 1, 1 );
        fprintf( 'Use the stack to get to <a href="matlab:%s">the place the assertion failed</a> to \n', cmd );
        fprintf( 'investigate the error. Then press F5 to <a href="matlab:dbcont;">continue</a> or <a href="matlab:dbquit;">stop debugging</a>.\n' )
        keyboard;
    else
        warning([mfilename ':condition'], sprintf( '%s: %s', mfilename, message ) );
    end
end
