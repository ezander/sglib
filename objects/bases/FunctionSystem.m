classdef (HandleCompatible=false) FunctionSystem < SglibObject
    % FUNCTIONSYSTEM Abstract base class for systems of basis functions.
    %
    % See also POLYNOMIALSYSTEM
        
    %   Elmar Zander, Aidin Nojavan
    %   Copyright 2015, Inst. of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    
    methods (Abstract)
        y=evaluate(polysys, xi); %EVALUATE Evaluates the basis functions at given points.
    end 
    
    methods
        function syschar=get_default_syschar(~)
            % GET_DEFAULT_SYSCHAR Return the default syschar for the function system.
            %   SYSCHAR=GET_DEFAULT_SYSCHAR(POLYSYS) returns the default
            %   SYSCHAR, which is used e.g. in the GPC germ specs as a
            %   shorthand to specify the polynomial system. Should be
            %   overwritten by derived classes, if appropriate. Returns an
            %   empty string, if there is no sensible default.
            syschar = '';
        end
    end
end
