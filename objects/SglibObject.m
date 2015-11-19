classdef SglibObject
    
    methods (Abstract)
        str=tostring(obj);
    end
    
    methods (Access=protected)
        function bool = cmp_classes(obj1, obj2)
            bool = strcmp(class(obj1), class(obj2));
        end
        function bool = cmp_fields(obj1, obj2)
            fields = fieldnames(obj1);
            bool = true;
            for i=1:length(fields)
                bool = bool && isequal(obj1.(fields{i}), obj2.(fields{i}));
                if ~bool; break; end
            end
        end
    end
    
    methods
        
        function bool = eq(obj1, obj2)
            bool = cmp_classes(obj1, obj2) && cmp_fields(obj1, obj2);
            
        end
        
        function bool=ne(obj1, obj2)
            bool = ~eq(obj1, obj2);
        end

        
    end
    
end
