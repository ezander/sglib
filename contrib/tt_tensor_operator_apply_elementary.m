function U=tt_tensor_operator_apply_elementary(A,T)
% TT_TENSOR_OPERATOR_APPLY_ELEMENTARY Short description of tt_tensor_operator_apply_elementary.
%   TT_TENSOR_OPERATOR_APPLY_ELEMENTARY Long description of tt_tensor_operator_apply_elementary.
%
% Example (<a href="matlab:run_example tt_tensor_operator_apply_elementary">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

tt_available(true);
if isa(T,'ktensor')
    lambda=T.lambda;
    u=cellfun( @operator_apply, A, T.u(:)', 'UniformOutput', false );
    U=ktensor(lambda,u);
else
    error( 'contrib:tensor_toolbox:not_supported', 'Unsupported tensor type' );
end
