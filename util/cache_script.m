function [filename,hash]=cache_script( script, varargin )
% CACHE_SCRIPT Caches the results of a script.
%   CACHE_SCRIPT Long description of cache_script.
%
% Example (<a href="matlab:run_example cache_script">run</a>)
%
% See also

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


options=varargin2options(varargin);
[verbosity,options]=get_option( options, 'verbosity', 1 );
[check_base,options]=get_option( options, 'check_base', false );
check_unsupported_options(options,mfilename);

ws='caller';

% Check that the script to be caches exists
if ischar(script) && ~exist( script, 'file' )
    error( 'sglib:cache_script', 'Script ''%s'' does not exist or is not on the path', script );
end

% Find depencies of the script and the modifications times of all the
% dependencies and store them in the callers workspace in a variable name
% that is most probably not used
store.deps=find_deps( script );
store.dep_dates=cellfun( @filedate, store.deps );

if check_base
    tmp_name=[tempname '.mat'];
    evalin( 'base', strvarexpand( 'save $tmp_name$' ) );
    [status, base_hash]=hash_matfile( tmp_name );
    if status
        warning('sglib:cache_script', 'Could not hash base workspace (please ask the sglib author what that means)');
    end
    delete( tmp_name );
    store.base_hash = base_hash;
end

assignin( ws, 'really_long_and_strange_varname_493875ksdjfh', store );

% Create a hash number out the data in the callers workspace plus the
% variable that stored the dependencies
tmp_name=[tempname '.mat'];
evalin( ws, strvarexpand( 'save $tmp_name$' ) );
[status, hash]=hash_matfile( tmp_name );
have_cache_file = (status == 0);
delete( tmp_name );

% Convert function_handle to a script name if necessary (because otherwise
% evalin won't work)
if isa(script, 'function_handle')
    script=func2str(script);
end

% Create the path for storing the cache file
if have_cache_file
    path=cache_file_base();
    filename=fullfile( path,  hash );
else
    filename='';
end


% Check wether a file under the name <hash>.mat exists
if ~isempty(filename) && exist([filename '.mat'],'file' )
    % If yes, it must have been from a previous run of the script with the
    % exact same data, so we can just load it.
    if verbosity>0
        fprintf( '%s => loading: %s\n', script, filename );
    end
    evalin( ws, ['load ' filename] );
else
    % If no, we need to evaluate the script in caller's workspace and store
    % the results in the file <hash>.mat so that they can be loaded during
    % a following run
    if verbosity>0
        fprintf( '%s => recomputing\n', script );
    end
    
    if ~isempty(script)
        evalin( ws, script );
    end
    makesavepath( filename );
    if ~isempty(filename)
        evalin( ws, ['save ' filename] );
    end
end

% If user doesn't want to see the filename that was generated, clear the
% corresponding variable
if nargout==0
    clear filename
end
