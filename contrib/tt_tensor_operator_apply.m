function Y=tt_tensor_operator_apply( A, X )
% TT_TENSOR_OPERATOR_APPLY Short description of tt_tensor_operator_apply.
%   TT_TENSOR_OPERATOR_APPLY Long description of tt_tensor_operator_apply.
%
% Example (<a href="matlab:run_example tt_tensor_operator_apply">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Comuting
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% TODO: no reduction yet
% d=size(A,2);
% for i=1:d
%     check_condition( {A{1,i},X{i}}, 'match', true, {'A{1,i}','X{i}'}, mfilename );
% end

R=size(A,1);
for i=1:R
    Yn=tensor_operator_apply_elementary( A(i,:), X );
    if i==1
        Y=Yn;
    else
        Y=Y+Yn;
    end
end
