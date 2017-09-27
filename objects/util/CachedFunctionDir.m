classdef CachedFunctionDir < handle
    properties
        cached_function
        cache_filename
        verbosity = 0;
        version_tag = 0;
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
    end
    
    methods
        function cfunc=CachedFunctionDir(func, filename, varargin)
            % CACHEDFUNCTION Create a CacheFunction object
            options = varargin2options(varargin, mfilename);
            [version_tag, options] = get_option(options, 'version_tag', 0);
            [verbosity, options] = get_option(options, 'verbosity', 0);
            check_unsupported_options(options);
            
            cfunc.cache_filename = filename;
            cfunc.cached_function = func;
            cfunc.version_tag = version_tag;
            cfunc.verbosity = verbosity;
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
        
        function filename=get_filename(cfunc, basename)
            filename = [fullfile(cfunc.cache_filename, basename), '.mat'];
        end
        
        function store(cfunc, args, result)
            hashstr=cfunc.get_hashstr(args);
            filename = cfunc.get_filename(hashstr);
            makesavepath( filename );
            save(filename, 'args', 'result');
        end
        
        function [result, found, origargs] = retrieve(cfunc, args)
            hashstr=cfunc.get_hashstr(args);
            filename = cfunc.get_filename(hashstr);
            
            result = [];
            origargs = [];
            found = exist(filename, 'file');
            if found
                if cfunc.verbosity>0
                    disp('Looking up response...');
                end
                load(filename, 'result', 'args');
                % todo: compare args and origargs
                origargs = args;
            end
        end
    end
    
end
