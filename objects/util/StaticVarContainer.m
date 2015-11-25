classdef StaticVarContainer < dynamicprops
    % STATICVARCONTAINER Helper class for implementing static properties in classes.
    %   STATICVARCONTAINER can be used in order to implement static
    %   properties. See the example for help on usage.
    %
    % Example
    %     classdef ClassWithCounter
    %         properties (Constant)
    %             static = StaticVarContainer('counter', 0);
    %         end
    %         methods
    %             function obj=ClassWithCounter()
    %                 obj.static.counter = obj.static.counter + 1;
    %             end
    %         end
    %         methods (Static)
    %             function c=get_counter()
    %                 c = ClassWithCounter.static.counter;
    %             end
    %         end
    %     end
    %
    % See also
    
    %   Elmar Zander
    %   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    
    methods
        function obj=StaticVarContainer(varargin)
            % STATICVARCONTAINER Construct a StaticVarContainer.
            %   OBJ=STATICVARCONTAINER(PROP1, VAL1, PROP2, VAL2, ...)
            %   constructs a container for the static properties PROP1,
            %   PROP2, ... which are initialised to the values VAL1, VAL2,
            %   ...
            for i=1:2:numel(varargin)
                obj.addprop(varargin{i});
                obj.(varargin{i}) = varargin{i+1};
            end
        end
    end
end
