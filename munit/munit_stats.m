function stats=munit_stats(cmd,varargin)
% MUNIT_STATS Internal function to handle munit statistics.
%   MUNIT_STATS is a function used to set and retrieve statistics gathered
%   during munit runs. This function is used internally in the munit
%   testing framework.
%
% Example (<a href="matlab:run_example munit_stats">run</a>)
%
% See also MUNIT_RUN_TESTSUITE

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

% persistent var to keep stats during calls
persistent munit_stats; 
mlock;

if nargin<1
    cmd='get';
end

if isempty(munit_stats)
    munit_stats=init_stats(0);
end

switch cmd
    case {'reset', 'init'}
        munit_stats=init_stats(0, varargin{:});
    case 'get'
        if isempty(munit_stats)
            error( 'munit_stats:empty', 'No stats on the stack, call reset first.' );
        end
        if isempty(varargin)
            stats=munit_stats(end);
        elseif length(varargin)==1 && ischar(varargin{1})
            stats=munit_stats(end).(varargin{1});
        end
    case 'set'
        if isempty(munit_stats)
            error( 'munit_stats:empty', 'No stats on the stack, call reset first.' );
        end
        if length(varargin)==1 && isstruct(varargin{1})
            munit_stats(end)=varargin{1};
        elseif length(varargin)==2 && ischar(varargin{1})
            munit_stats(end).(varargin{1})=varargin{2};
        else 
            error( 'munit_stats:set', 'Pass either a stats struct or fieldname plus value combination.' );
        end
    case 'push'
        old_stats=munit_stats(end);
        stats=init_stats( munit_stats(end).total_assertions, varargin{:} );
        if strcmp(old_stats.total_module_name,'<unknown>')
            stats.total_module_name=stats.module_name;
        else
            stats.total_module_name=[old_stats.total_module_name, '/', stats.module_name];
        end
        munit_stats(end+1)=stats;
    case 'pop'
        ls=munit_stats(end);
        munit_stats(end)=[];
        ns=munit_stats(end);
        ns.total_assertions=ls.total_assertions;
        ns.total_assertions_module=ns.total_assertions_module+ls.total_assertions_module;
        ns.assertions_failed=ns.assertions_failed+ls.assertions_failed;
        ns.assertions_failed_poss=ns.assertions_failed_poss+...
            ls.assertions_failed_poss;
        ns.tested_functions=horzcat(ns.tested_functions, ls.tested_functions);
        munit_stats(end)=ns;
        stats=ns;
    case {'add','test'}
        ns=munit_stats(end);
        func=varargin{1};
        passed=varargin{2};
        fuzzy=false;
        if length(varargin)>=3; fuzzy=varargin{3}; end
        
        ns.current_assertion=ns.current_assertion+1;
        ns.total_assertions=ns.total_assertions+1;
        ns.total_assertions_module=ns.total_assertions_module+1;
        if ~passed
            if fuzzy
                ns.assertions_failed_poss=ns.assertions_failed_poss+1;
            else
                ns.assertions_failed=ns.assertions_failed+1;
            end
        end
        ns.tested_functions{end+1}=func;
        munit_stats(end)=ns;
    otherwise
        error( 'munit_stats:unknown_cmd', 'Unknown command: %s.', cmd );
end


function stats=init_stats( total_assertions, module_name )
if nargin<2
    module_name='<unknown>';
end
stats.module_name=module_name;
stats.total_module_name=module_name;
stats.function_name='<unknown>';
stats.current_assertion=0;
stats.assertions_failed=0;
stats.assertions_failed_poss=0;
stats.total_assertions=total_assertions;
stats.total_assertions_module=0;
stats.tested_functions={};
