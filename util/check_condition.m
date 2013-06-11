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
%     options=struct( 'mode', 'print' );
%     %pass
%     check_condition( x, 'vector', false, 'x', mfilename, options );
%     check_condition( [], 'vector', true, '?', mfilename, options );
%     check_condition( 1, 'scalar', true, '1', mfilename, options );
%     check_condition( A, 'square', true, 'A', mfilename, options );
%     check_condition( @check_condition, 'function', false, '@cf', mfilename, options );
%     check_condition( {A,B}, 'match', false, {'A','B'}, mfilename, options );
%     check_condition( {A,[]}, 'match', true, {'A','?'}, mfilename, options );
%     check_condition( {x,'double'}, 'isa', false, x, mfilename, options );
%     disp( 'No warning should have appeared until now. But now they come...');
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


switch varcond
    case {'vector', 'isvector'}
        ok=check_vector( x, emptyok, varname, mfilename, varargin{:} );
    case {'scalar', 'isscalar'}
        ok=check_scalar( x, emptyok, varname, mfilename, varargin{:} );
    case {'square', 'issquare' }
        ok=check_matrix( x, 'square', emptyok, varname, mfilename, varargin{:} );
    case {'function', 'isfunction'}
        ok=check_function( x, emptyok, varname, mfilename, varargin{:} );
    case 'match'
        ok=check_match( x{1}, x{2}, emptyok, varname{1}, varname{2}, mfilename, varargin{:} );
    case {'class', 'isa'}
        ok=check_type( x{1}, x{2}, emptyok, varname, mfilename, varargin{:} );
    otherwise
        error([mfilename ':condition'], '%s: unknown condition to check: %s', mfilename, varcond );
end

if nargout==0
    clear ok;
end
