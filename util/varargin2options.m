function options=varargin2options( args )
% VARARGIN2OPTIONS Convert variable argument list to options structure.
%   OPTIONS=VARARGIN2OPTIONS( ARGS ) returns the variable arguments as
%   an options structure. This allows the user to pass the arguments in
%   different forms; see the following examples.
%   OPTIONS=VARARGIN2OPTIONS() returns an empty options structure.
%   OPTIONS=VARARGIN2OPTIONS( {STRARG1, VAL1, STRARG2, VAL2, ...}) returns an
%   a structure with the pairs STRARGN and VALN converted to fields in the
%   returned options structure (i.e. options.(STRARGN)=VALN).
%   OPTIONS=VARARGIN2OPTIONS( {OPTS} ) returns the options structure as it
%   was passed to this function.
%
% Example (<a href="matlab:run_example varargin2options show">run</a>)
%   % declare your own function to take varargs as options
%   function my_function( arg1, arg2, varargin )
%     options=varargin2options( varargin );
%   % now suppose my_function has a debug option which can take on boolean
%   % values true or false, then you can call as either ...
%   my_function( arg1, arg2, 'debug', true );
%   % ... or ...
%   options.debug = true;
%   my_function( arg1, arg2, options );
%
% See also GET_OPTION

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

stop_check;

% we need a cell array (don't pass varargin{:} any more, always pass
% varargin itself)
if ~iscell(args)
    error( 'util:varargin2options:no_cell', 'Argument must be a cell array' );
end

% if no args present return empty structure
if isempty(args)
    options=struct();
    return;
end

% one arg as structure means we can return the struct as is
if isstruct( args{1} )
    if length(args)>2
        error( 'util:varargin2options:struct', 'Wrong option specification: when struct is given only one argument is allowed' );
    end
    options=args{1};
    return
end

% options wrapped in a cell
if length(args)==1 && iscell(args{1})
    args=args{1};
end

names=args(1:2:end);
values=args(2:2:end);
if ~iscellstr(names)
    error( 'util:varargin2options:invalid_names', 'Wrong option specification: not all option names are strings: %s', evalc( 'disp(names);' ) );
end
if length(names)~=length(values)
    error( 'util:varargin2options:missing_value', 'Wrong option specification: not all option names have a corresponding value' );
end
[unames,ind]=unique(names);
unames;%#ok (we only need ind)
options=cell2struct( values(ind), names(ind), 2 );
