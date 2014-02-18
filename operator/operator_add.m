function A=operator_add(A1, A2)
% OPERATOR_ADD Short description of operator_add.
%   OPERATOR_ADD Long description of operator_add.
%
% Options
%
% References
%
% Notes
%
% Example (<a href="matlab:run_example operator_add">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2014, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

%options=varargin2options(varargin);
%check_unsupported_options(options,mfilename);

if isnumeric(A1)
    % A is a matrix (meaningsless result for identity)
    A=A1+A2;
elseif is_tensor_operator(A1)
    A=tensor_operator_add(A1, A2);
elseif iscell(A1) && isfunction(A1{2})
    % A is an operator and first element is the size
    s1=operator_size(A1);
    s2=operator_size(A2);
    assert(all(s1==s2));
    A=operator_from_function( funcreate(@operator_sum, A1, A2, @funarg, @ellipsis), s1 );
else
    error( 'sglib:operator_add:type', 'Linear operator is neither a matrix nor a cell array' );
end



function y = operator_sum(A1, A2, x, varargin);
y1=operator_apply( A1, x, 'pass_on', varargin );
y2=operator_apply( A2, x, 'pass_on', varargin );
y = tensor_add(y);


