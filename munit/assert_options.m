function options=munit_options(cmd,varargin)
% MUNIT_OPTIONS Short description of munit_options.
%   MUNIT_OPTIONS Long description of munit_options.
%
% Example (<a href="matlab:run_example munit_options">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% persistent var to keep options during calls
persistent munit_options;

if nargin<1
    cmd='get';
end

switch cmd
    case {'reset', 'init'}
        munit_options=init_options();
    case 'get'
        if isempty(munit_options)
            munit_options=init_options();
        end
        options=munit_options(end);
    case 'set'
        if isempty(munit_options)
            munit_options=init_options();
        end
        munit_options.(varargin{1})=varargin{2};
    otherwise
        error( 'munit_options:unknown_cmd', 'Unknown command: %s.', cmd );
end


function options=init_options()
options.debug=false;
options.abstol=1e-8;
options.reltol=1e-8;
options.max_assertion_disp=10;
options.output_func=@display_func;

function display_func( s )
stdin=1;
fprintf( stdin, '%s\n', s );
