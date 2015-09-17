classdef SimParameter < handle
    properties (GetAccess=public, SetAccess=protected)
        name
        dist
        is_fixed
        fixed_val
    end
    
    methods
        function simparam=SimParameter(name, dist)
            % Returns a new SimParameter object with the distribution DIST
            % which was specified as an argument, and IS_FIXED set to false
            
            % NAME is a string that contains a human readable form of the
            % parameter description
            
            % Maybe make sure that dist is really derived from the
            % Distribution class
        end
        
        function set_fixed(simparam, val)
            % Fixes the parameter to the value VAL and sets IS_FIXED 
        end

        function set_to_mean(simparam)
            % Fixes the parameter to the value VAL to the mean of the
            % distribution
        end
        
        function set_dist(simparam, dist)
            % Sets a new distribution and resets the IS_FIXED variable
        end
        
        function set_not_fixed(simparam)
            % Sets the SimParam to be not fixed
        end
        
%         function str=tostring(simparam)
%             str=sprintf('Parameter(%s,%s)\n', 'kappa', simparam.dist.tostring());
%         end
%         
%         function disp(simparam)
%             disp(simparam.tostring());
%         end
    end
end
