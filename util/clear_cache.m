function clear_cache(varargin)
% CLEAR_CACHE Clears the file cache.
%   CLEAR_CACHE(OPTIONS) removes cache files that were created by the
%   cache_script function. 
%
% Options
%   remove_all: {false}, true
%     Removes all cache files, independent of whether they might be still
%     needed or not.
%   simulate: {false}, true
%     Only shows what would be deleted, but doesn't acutally delete the
%     files.
%   verbosity: 1
%     Sets the verbosity level. On 1 deleted files will be shown, on 2 also
%     kept files are shown.
%
% Example (<a href="matlab:run_example clear_cache">run</a>)
%   clear_cache('verbosity', 2, 'simulate', true);
%
% See also CACHE_SCRIPT

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin,mfilename);
[remove_all, options]=get_option(options,'all',false);
[simulate, options]=get_option(options,'simulate',false);
[verbosity, options]=get_option(options,'verbosity',1);
check_unsupported_options(options);


path=cache_file_base();
varname='really_long_and_strange_varname_493875ksdjfh';

s=dir(fullfile(path,'*.mat'));
for i=1:length(s)
    filename = fullfile(path, s(i).name);
    remove_it = remove_all;
    
    if ~remove_it
        % check whether deps are outdated
        data=load(filename);
        
        if isfield(data, varname)
            store = data.(varname);
            old_dates = store.dep_dates;
            new_dates = cellfun( @filedate, store.deps );
            remove_it = any(old_dates~=new_dates);
        end
    end
    
    if remove_it
        if verbosity>0
            fprintf('Removing: %s\n', filename);
            if ~simulate
                delete(filename);
            end
        end
    else
        if verbosity>1
            fprintf('Keeping:  %s\n', filename);
        end
    end
end

