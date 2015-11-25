classdef SglibHandleObject < SglibObject & handle
    % SGLIBOBJECT Base class for handle classes in sglib.
    %   This class derives from SGLIBOBJECT and HANDLE and resolves the
    %   conflicts in the EQ and NE methods.
    %
    % See also SGLIBOBJECT HANDLE
    
    %   Elmar Zander
    %   Copyright 2015, Institute of Scientific Computing, TU Braunschweig
    %
    %   This program is free software: you can redistribute it and/or modify it
    %   under the terms of the GNU General Public License as published by the
    %   Free Software Foundation, either version 3 of the License, or (at your
    %   option) any later version.
    %   See the GNU General Public License for more details. You should have
    %   received a copy of the GNU General Public License along with this
    %   program.  If not, see <http://www.gnu.org/licenses/>.
    
    methods
        function bool = eq(obj1, obj2)
            % EQ Compare objects for equality.
            %   Compares classes for exact equality and then the fields of
            %   the respective objects. It is usually advisable to
            %   overwrite CMP_FIELDS instead of overwriting this method.
            bool = eq@SglibObject(obj1, obj2);
        end
        
        function bool=ne(obj1, obj2)
            % NE Compare objects for inequality.
            %   Negates the result of EQ(OBJ1,OBJ2), which is usually what
            %   you want. If this methods is overwritten it should always
            %   be ensured that the relation ~EQ(OBJ1,OBJ2)==NE(OBJ1,OBJ2)
            %   holds.
            bool = ne@SglibObject(obj1, obj2);
        end
    end
    
    %% Inherited methods from handle class, not needed in sglib
    % Those are made hidden so they don't clutter up the tab completion and
    % the object display. Unfortunately, forwarding to the orginal methods
    % did not work here.
    methods (Hidden)
        varargout=addlistener(obj,varargin);
        varargout=delete(obj,varargin);
        varargout=findobj(obj,varargin);
        varargout=findprop(obj,varargin);
        %varargout=isvalid(obj,varargin); % cannot hide this, as its 
        varargout=notify(obj,varargin);
    end
end
