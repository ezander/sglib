classdef DecomposedMatrixOperator
    properties
        L, d, U
        inv_flag
    end
    methods(Access=protected)
        function y=ldu_apply(lduop, x)
        end
        function x=ldu_solve(lduop, y)
        end
        function y=apply_or_solve(lduop, x, inv_flag)
            if inv_flag==lduop.inv_flag
                y=ldu_apply(lduop, x);
            else
                y=ldu_solve(lduop, x);
            end
        end
    end
    methods
        function y=apply(lduop, x)
            y = apply_or_solve(lduop, x, false);
        end
        function x=solve(lduop, y)
            y = apply_or_solve(lduop, x, true);
        end
        function A=asmatrix(lduop)
            if inv_flag
            else
                A = L*spdiags(d,0,size(L)) * U;
            end
        end
        function s=size_impl(lduop)
            s = size(L);
        end
        function lduop=inv(lduop)
            lduop=DecomposedMatrixOperator(lduop.L, lduop.d, lduop.U, ~lduop.inv_flag)
        end
    end
end