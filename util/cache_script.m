function [filename,hash]=cache_script( script, varargin )


options=varargin2options(varargin);
[verbosity,options]=get_option( options, 'verbosity', 1 );
check_unsupported_options(options,mfilename);

ws='caller';

if ischar(script) && ~exist( script, 'file' )
    error( 'sglib:cache_script', 'Script ''%s'' does not exist or is not on the path', script );
end

store.deps=find_deps( script );
store.dep_dates=cellfun( @filedate, store.deps );
assignin( ws, 'really_long_and_strange_varname_493875ksdjfh', store );

tmp_name=[tempname '.mat'];
evalin( ws, strvarexpand( 'save $tmp_name$' ) );
[status, hash]=hash_matfile( tmp_name );
have_cache_file = (status == 0);
delete( tmp_name );

if isa(script, 'function_handle')
    script=func2str(script);
end

if have_cache_file
    path=cache_file_base();
    filename=fullfile( path,  hash );
else
    filename='';
end


if ~isempty(filename) && exist([filename '.mat'],'file' )
    if verbosity>0
        fprintf( '%s => loading: %s\n', script, filename );
    end
    evalin( ws, ['load ' filename] );
else
    % Now evaluate the script in base workspace
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

if nargout==0
    clear filename
end
