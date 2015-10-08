function options=munit_options(cmd,varargin)
% MUNIT_OPTIONS Set or get Munit options.
%   MUNIT_OPTIONS(CMD,VARARGIN) gets, sets or resets munit options. Usually
%   this function is called only internally, or from SGLIB_SETTINGS.
%
% Example (<a href="matlab:run_example munit_options">run</a>)
%   munit_options('get')
%
% See also SGLIB_SETTINGS

%   Elmar Zander
%   Copyright 2009, Inst. of Scientific Computing
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
mlock;

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
        if isempty(varargin)
            options=munit_options;
        elseif length(varargin)==1 && ischar(varargin{1})
            options=munit_options.(varargin{1});
        end
    case 'set'
        if isempty(munit_options)
            munit_options=init_options();
        end
        if length(varargin)==1 && isstruct(varargin{1})
            munit_options=varargin{1};
        elseif length(varargin)==2 && ischar(varargin{1})
            munit_options.(varargin{1})=varargin{2};
        else 
            error( 'munit_options:set', 'Pass either a stats struct or fieldname plus value combination.' );
        end
    otherwise
        error( 'munit_options:unknown_cmd', 'Unknown command: %s.', cmd );
end

function options=init_options()
options.function_name='<unknown>';
options.debug=false;
options.fuzzy=false;
options.abstol=1e-8;
options.reltol=1e-8;
options.max_assertion_disp=10;
options.prefix='unittest_';
options.output_func=@display_func;
options.compact=0;
options.equalnan=true;
options.equalinf=true;
options.on_error='debug';

function display_func( s )
stdin=1;
fprintf( stdin, '%s\n', s );
