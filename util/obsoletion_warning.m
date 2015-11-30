function obsoletion_warning(func, replacement, message, varargin)
% OBSOLETION_WARNING Short description of obsoletion_warning.
%   OBSOLETION_WARNING(VARARGIN) Long description of obsoletion_warning.
%
% Example (<a href="matlab:run_example obsoletion_warning">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2015, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin, mfilename);
[is_class,options]=get_option(options, 'is_class', false);
check_unsupported_options(options);

type='Function';
if is_class
    type='Class';
end
msg=strvarexpand('$type$ $func$ is obsolete. Please use $replacement$ instead.');
if nargin>=3 && ~isempty(message)
    msg = [msg sprintf('\n         ') message];
end
func_id = strrep(func, '.', '_');

warning(['sglib:obsolete:', func_id], msg);
