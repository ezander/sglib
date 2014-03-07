classdef TensorOperator < Operator
    properties
        A
    end
    methods
        function tenop=TensorOperator(A)
            assert(iscell(A), 'A must be a cell array of matrices or operators');
            tenop.A=A;
        end
        
        function y=apply(tenop, x)
            y = tensor_operator_apply(tenop.A, x);
        end
        
        function s=size_impl(tenop)
            s = tensor_operator_size(tenop.A, false);
        end
        
        function A=asmatrix(tenop)
            A=tensor_operator_to_matrix(tenop.A);
        end
    end
end
