function options=varargin2options( varargin )
% VARARGIN2OPTIONS Convert variable argument list to options structure.
%   OPTIONS=VARARGIN2OPTIONS( VARARGIN ) returns the variable arguments as
%   an options structure. This allows the user to pass the arguments in
%   different forms; see the following examples.
%   OPTIONS=VARARGIN2OPTIONS() returns an empty options structure. 
%   OPTIONS=VARARGIN2OPTIONS( STRARG1, VAL1, STRARG2, VAL2, ...) returns an 
%   a structure with the pairs STRARGN and VALN converted to fields in the
%   returned options structure (i.e. options.(STRARGN)=VALN).
%   OPTIONS=VARARGIN2OPTIONS( OPTS ) returns the options structure as it 
%   was passed to this function.
%
% Example (<a href="matlab:run_example varargin2options show">run</a>)
%   % declare your own function to take varargs as options
%   function my_function( arg1, arg2, varargin )
%     options=varargin2options( varargin{:} );
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
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


if isempty(varargin)
    options=struct();
elseif isstruct( varargin{1} )
    options=varargin{1};
else
    if iscell( varargin{1} )
        c=varargin{1};
    else
        c=varargin;
    end
    try
        options=cell2struct( c(2:2:end), c(1:2:end), 2 );
    catch
        % most probable cause: number of preceding arguments wrong
        error( 'varargin2options:options', 'wrong option specification: %s', evalc( 'disp(varargin);' ) );
    end
end
options.fields__={};
