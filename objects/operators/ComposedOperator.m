classdef ComposedOperator < Operator
    properties
        op1, op2
    end
    methods
        function compop=ComposedOperator(op1, op2)
            compop.op1=op1;
            compop.op2=op2;
        end
        
        function y=apply(compop, x)
            z = compop.op1.apply(x);
            y = compop.op2.apply(z);
        end
        
        function s=size_impl(compop)
            s1=size_impl(compop.op1);
            s2=size_impl(compop.op2);
            s=[s2(:,1), s1(:,2)];
        end
        
        function x=solve(compop, y)
            z = compop.op2.solve(y);
            x = compop.op1.solve(z);
        end
        
        
        function A=asmatrix(compop)
            A=compop.op2.asmatrix() * compop.op1.asmatrix();
        end
    end
    
end
