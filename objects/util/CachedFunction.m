classdef CachedFunction
    properties
        result_cache@containers.Map
        cached_function
        cache_filename
        verbosity = 0;
        version_tag = 0;
    end
    
    
    methods(Static)
        function hashstr=get_hashstr(data)
            % GET_HASHSTR Generate unique hash value from data
            digest = java.security.MessageDigest.getInstance('SHA1');
            data = typecast(data, 'uint8');
            digest.update(data)
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
            save(filename, 'cache', 'version_tag');
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
            cfunc.cached_function = func;
            cfunc.version_tag = version_tag;
            cfunc.verbosity = verbosity;
        end
        
        function result=call(cfunc, varargin)
            % CALL Call the function or get the result from the cache
            args = varargin;
            [result, found] = model.cached_function.retrieve(args);
            if ~found
                result = funcall(cfunc.cached_function, args{:});
                model.cached_function.store(args, result);
            end
        end
        
        function store(cfunc, args, result)
            hashstr=cfunc.get_hashstr(args);
            cfunc.result_cache(hashstr) = {result, args};
            cfunc.save_cache_file(cfunc.cache_filename, ...
                cfunc.result_cache, cfunc.version_tag, cfunc.verbosity);
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
