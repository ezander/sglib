classdef MatrixOperator < Operator
    properties
        A
    end
    methods
        function obj=MatrixOperator(A)
            obj.A=A;
        end
        
        function y=apply(obj, x)
            y = obj.A*x;
        end
        
        function s=size_impl(obj)
            s=size(obj.A);
        end

        function x=solve(obj, y)
            x = obj.A\y;
        end

        function A=asmatrix(obj)
            A=obj.A;
        end
    end
    methods(Static)
        function op=wrap_if_necessary(op)
            if ~isempty(op) && isnumeric(op)
                op=MatrixOperator(op);
            end
        end
    end
end
