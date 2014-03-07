classdef UpdatableOperator < Operator
    methods(Abstract)
        newop = update(op, varargin);
    end
    
    methods
        function invop=inv(op)
            invop = InverseUpdatableOperator(op);
            %invop = InverseOperator(op);
        end
    end
end
