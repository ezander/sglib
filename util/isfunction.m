function bool=isfunction( var )
% ISFUNCTION Determine whether VAR is callable via FUNCALL.
%   BOOL=ISFUNCTION( VAR ) returns true if VAR can be passed as a first
%   argument to FUNCALL.
%
% Example (<a href="matlab:run_example isfunction">run</a>)
%   if isfunction( func )
%     funcall( func, a, b );
%   end
%
% See also FUNCALL

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


if iscell( var )
    bool=isfunction( var{1} );
else
    bool=ischar(var);
    bool=bool || isa(var,'function_handle') || isa(var,'inline');
    bool=bool || isa(var,'function handle') || isa(var,'inline function') ;
end
