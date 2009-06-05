function ok=check_unsupported_options( options, mfilename )
% CHECK_UNSUPPORTED_OPTIONS Check whether unsupported options were passed.
%   OK=CHECK_UNSUPPORTED_OPTIONS( options, mfilename ) checks whether there
%   are entries left over in the OPTIONS struct, indicating that the user
%   probably called the function with a wrong or unsupported option. This
%   function provided a nice way to inform the user of such mistakes (most
%   probably spelling mistakes). CHECK_UNSUPPORTED_OPTIONS returns true, if
%   there were no fiels left over in OPTIONS, and false otherwise. In the
%   latter case a warning about unsupported options for function MFILENAME 
%   is issued. 
%
%   Note 1: for this method to work you have to call GET_OPTION with two
%   output arguments, so that used options are eliminated from the options
%   structure. 
%
%   Note 2: pass mfilename literally for the second argument (i.e. pass the
%   return value of the buildin function 'mfilename' which tells you the
%   name of the current script, and is thus exactly what you want.)
%
% Example (<a href="matlab:run_example check_unsupported_options">run</a>)
%   % declare your own function to take varargs as options
%   function my_function( arg1, arg2, varargin )
%
%     options=varargin2options( varargin{:} );
%     [opt1,options]=get_option( options, 'opt1', default1 );
%     [opt2,options]=get_option( options, 'opt2', default2 );
%     [opt3,options]=get_option( options, 'opt3', default3 );
%     check_unsupported_options( options, mfilename );
%
% See also VARARGIN2OPTIONS, GET_OPTION

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

%if ~exist('mfilename','var') || isempty(mfilename)
%    mfilename='global';
%end

fields=fieldnames( options );
if isempty(fields) || (length(fields)==1 && strcmp( fields{1}, 'fields__') )
    ok=true;
    return;
end

ok=false;
if isfield( options, 'fields__' )
    supported_fields=options.fields__;
    options=rmfield( options, 'fields__' );
else
    supported_fields=[];
end

fields=fieldnames(options);
for i=1:length(fields)
    warning([mfilename ':options'], '%s: unsupported options detected: %s', ...
        mfilename, fields{i} );
end

if ~isempty( supported_fields )
    fprintf( 'Valid fields for "%s" are: %s \n', mfilename, supported_fields );
end

