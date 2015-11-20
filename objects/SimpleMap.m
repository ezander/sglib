classdef SimpleMap < SglibHandleObject
    
    properties (Access=protected)
        key_lookup = struct();
    end
    
    properties (SetAccess=protected)
        keys = {};
        values = {};
    end
    
    methods
        function map=SimpleMap()
        end
        
        function num=count(map)
            num=numel(map.values);
        end
      
        function index=find_key(map, key)
            if ~map.iskey(key)
                index=0;
            else
                index=map.key_lookup.(key);
            end
        end
        
        function bool=iskey(map, key)
            bool = isfield(map.key_lookup, key);
        end
    
        function add(map, key, value)
            index = map.find_key(key);
            if ~index
                index = map.count()+1;
                map.key_lookup.(key)=index;
                map.keys{index,1} = key;
            end
            map.values{index,1}=value;
        end
        
        function value=get(map, key, default)
            if ischar(key)
                index = map.find_key(key);
            else
                index = key;
            end
            if index
                value = map.values{index};
            else
                value = default;
            end
        end
        
        function str=tostring(map)
            str = '';
            for i=1:map.count()
                if i>1
                    str = [str, ', '];
                end
                str = [str, strvarexpand('$map.keys{i}$ => $map.values{i}$')];
            end
            str = ['Map(', str, ')'];
        end
    end
end