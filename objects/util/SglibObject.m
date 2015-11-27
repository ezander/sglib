classdef (HandleCompatible=true) SglibObject
    % SGLIBOBJECT Base class for classes in sglib, providing some basic functionality.
    %   SGLIBOBJECT as a base class provides some basic functionality to
    %   derived classes, namely testing for object equality (EQ) and
    %   inequality (NE), displaying of objects (DISP,DISPLAY). It furthers
    %   acts as some kind of marker (via ISA) for some sglib functions, in
    %   order to work with those objects (e.g. ASSERT_EQUALS).
    %
    % Example (<a href="matlab:run_example SglibObject">run</a>)
    %
    % See also
    
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
    
    methods (Access=protected)
        function bool = cmp_classes(obj1, obj2)
            % CMP_CLASSES Test whether to objects are of the exact same class.
            %   Note derived classes don't compare equal, as that gives
            %   problems with the necessary symmetry of equality testing.
            bool = strcmp(class(obj1), class(obj2));
        end
        function bool = cmp_fields(obj1, obj2)
            % CMP_FIELDS Compares all fields in one object to the fields in the other.
            %   Should only be called if the classes are known to be equal.
            %   Can be overwritten for stability/efficiency reasons in
            %   derived classes where the fields are known.
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
            % EQ Compare objects for equality.
            %   Compares classes for exact equality and then the fields of
            %   the respective objects. It is usually advisable to
            %   overwrite CMP_FIELDS instead of overwriting this method.
            bool = cmp_classes(obj1, obj2) && cmp_fields(obj1, obj2);
        end
        
        function bool=ne(obj1, obj2)
            % NE Compare objects for inequality.
            %   Negates the result of EQ(OBJ1,OBJ2), which is usually what
            %   you want. If this methods is overwritten it should always
            %   be ensured that the relation ~EQ(OBJ1,OBJ2)==NE(OBJ1,OBJ2)
            %   holds.
            bool = ~eq(obj1, obj2);
        end
    end
    
    methods (Sealed)
        function str=base_tostring(obj)
            str = evalc('builtin(''disp'',obj)');
        end
    end
    methods
        function str=tostring(obj)
            str = base_tostring(obj);
        end
    end
    
    
    methods(Static)
        function mode=set_disp_mode(new_mode)
            % SET_DISP_MODE Set the disp mode.
            %   MODE=SET_DISP_MODE(NEW_MODE) Sets the mode for the DISP
            %   function. NEW_MODE==1 means using the TOSTRING function of
            %   the object, NEW_MODE==2 uses the builtin DISP function, and
            %   NEW_MODE==3 (the default) uses the TOSTRING function, but
            %   provides a clickable link, which will show the original
            %   DISP output.
            %
            %   See also DISP GET_DISP_MODE
            persistent saved_mode
            if isempty(saved_mode)
                saved_mode=3;
            end
            if nargin>0
                saved_mode=new_mode; 
            end
            mode = saved_mode;
        end
        function mode=get_disp_mode
            % GET_DISP_MODE Get the disp mode.
            %   See also SET_DISP_MODE
            mode = SglibObject.set_disp_mode();
        end
    end
    
    methods
        function disp(obj)
            % DISP Show the object.
            %   See also SET_DISP_MODE
            mode = obj.get_disp_mode();
            switch mode
                case 1
                    str = tostring(obj);
                case 2
                    str = base_tostring(obj);
                case 3
                    str1 = tostring(obj);
                    str2 = base_tostring(obj); %#ok<NASGU>
                    if strcmp(str1,str2)
                        str = str1;
                    else
                        str2 = strvarexpand('$double(str2)$','maxarr',inf);
                        str2(str2==' ')=[]; %#ok<NASGU>
                        str3 = '';
%                         div = find(str1=='(' | str1=='[' | str1=='{', 1, 'first');
%                         if ~isempty(div) && div>1
%                             str3 = str1(div:end); %#ok<NASGU>
%                             str1 = str1(1:div-1); %#ok<NASGU>
%                         else
%                             str3 = ''; %#ok<NASGU>
%                         end
                        %str = strvarexpand('<a href="matlab:disp(char($str2$))">$str1$</a>$str3$');
                        str = strvarexpand('$str1$$str3$ $char(10)$<a href="matlab:disp(char($str2$))">(show)</a>');
                    end
            end
            disp(str);
        end
    end
end
