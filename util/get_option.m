function [val,options]=get_option( options, field, default )
% GET_OPTION Get a user option or return the default.
%   VAL=GET_OPTION( OPTIONS, FIELD, DEFAULT ) return the value of
%   OPTIONS.FIELD where FIELD is a string containing the structure field
%   containing the option, or DEFAULT is the field is not present. Useful
%   inside functions that can have a bunch of optional arguments.
%   If OPTIONS is also specified as output argument the field (if present)
%   is removed from the struct. This feature can be used to make sure only
%   valid options were passed to the function (struct should be empty after
%   all options have been queried.)
%   DEFAULT may also be a struct, in which case a the field DEFAULT.FIELD
%   will be used as default (this field must exist, no check is made for
%   existence).
%
% Example (<a href="matlab:run_example get_option">run</a>)
%   function retval=my_function( arg1, arg2, arg3, varargin );
%     options = varargin2options( varargin );
%     [option1,options] = get_option( options1, 'option1', 1234 );
%     check_unsupported_options( options, mfilename );
%
% See also VARARGIN2OPTIONS, CHECK_UNSUPPORTED_OPTIONS

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



if ~isstruct(options)
    error( 'First argument to get_option must be a struct (maybe you interchanged options and field?)' );
elseif ~ischar(field)
    error( 'Second argument to get_option must be a string (maybe you interchanged options and field?)' );
end

if isfield( options, field )
    val=options.(field);
    if nargout>1
        options=rmfield(options,field);
        options.fields__={options.fields__{:}, field};
    end
else
    if isstruct(default)
        val=default.(field);
    else
        val=default;
    end
end
