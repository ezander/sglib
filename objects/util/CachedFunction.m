classdef CachedFunction < handle
    properties
        result_cache@containers.Map
        cached_function
        cache_filename
        verbosity = 0;
        version_tag = 0;
        
        last_save_time = -inf;
        %always_save = true;
        always_save = false;
        unsaved_changes = false;
    end
    
    
    methods(Static)
        function hashstr=get_hashstr(args)
            % GET_HASHSTR Generate unique hash value from data
            digest = java.security.MessageDigest.getInstance('SHA1');
            for i=1:length(args)
                data = typecast(args{i}, 'uint8');
                digest.update(data)
            end
            hash = typecast(digest.digest(), 'uint8');
            hashstr = sprintf('%.2X', hash);
        end
        
        function cache=load_cache_file(filename, req_version_tag, verbosity)
            % LOAD_CACHE_FILE Load cache from file or generate new cache object
            try
                load(filename, 'cache', 'version_tag');
                if verbosity>0
                    disp('Cache loaded...');
                end
                if version_tag ~= req_version_tag
                    cache = containers.Map();
                end
            catch ME
                if verbosity>0
                    disp(ME.message);
                end
                cache = containers.Map();
            end
        end
        
        function save_cache_file(filename, cache, version_tag, verbosity)
            % SAVE_CACHE_FILE Save the cache to a file
            if verbosity>=2
                strvarexpand('Saving cache file "$filename$" ($datestr(now)$');
            end
            t=tic;
            save(filename, 'cache', 'version_tag', '-v7.3');
            dt=toc(t);
            if verbosity>=2 || (verbosity > 0 && dt>1)
                strvarexpand('Time for writing to cache file "$filename$": $dt$');
            end
        end
    end
    
    methods
        function cfunc=CachedFunction(func, filename, varargin)
            % CACHEDFUNCTION Create a CacheFunction object
            options = varargin2options(varargin, mfilename);
            [version_tag, options] = get_option(options, 'version_tag', 0);
            [verbosity, options] = get_option(options, 'verbosity', 0);
            check_unsupported_options(options);
            
            cfunc.cache_filename = filename;
            cfunc.result_cache = cfunc.load_cache_file(filename, version_tag, cfunc.verbosity);
            cfunc.unsaved_changes = false;
            cfunc.last_save_time = now();
            
            cfunc.cached_function = func;
            cfunc.version_tag = version_tag;
            cfunc.verbosity = verbosity;
        end
        
        function delete(cfunc)
            % DELETE Class destructor, should save the file, if not done already.
            if cfunc.unsaved_changes
                cfunc.save_cache_file(cfunc.cache_filename, ...
                    cfunc.result_cache, cfunc.version_tag, cfunc.verbosity);
                cfunc.unsaved_changes = false;
            end
        end
        
        function result=call(cfunc, varargin)
            % CALL Call the function or get the result from the cache
            args = varargin;
            [result, found] = cfunc.retrieve(args);
            if ~found
                result = funcall(cfunc.cached_function, args{:});
                cfunc.store(args, result);
            end
        end
        
        function do_save(cfunc)
            cfunc.save_cache_file(cfunc.cache_filename, ...
                cfunc.result_cache, cfunc.version_tag, cfunc.verbosity);
            cfunc.last_save_time = now();
            cfunc.unsaved_changes = false;
        end
        
        function store(cfunc, args, result)
            hashstr=cfunc.get_hashstr(args);
            cfunc.result_cache(hashstr) = {result, args};
            
            max_dt_in_minutes = 0.5;
            max_dt = (max_dt_in_minutes * 60) / (60*60*24);
            save_now = cfunc.always_save || cfunc.last_save_time<now - max_dt;
            if save_now
                cfunc.do_save();
            else
                cfunc.unsaved_changes = true;
            end
        end
        
        function [result, found, origargs] = retrieve(cfunc, args)
            hashstr=cfunc.get_hashstr(args);
            result = [];
            orig_args = [];
            found = cfunc.result_cache.isKey(hashstr);
            if found
                if cfunc.verbosity>0
                    disp('Looking up response...');
                end
                result_pair = cfunc.result_cache(hashstr);
                result = result_pair{1};
                origargs = result_pair{2};
            end
        end
    end
    
end
