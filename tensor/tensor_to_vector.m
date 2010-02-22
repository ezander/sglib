function t=tensor_to_vector(T)
% TENSOR_TO_VECTOR Short description of tensor_to_vector.
%   TENSOR_TO_VECTOR Long description of tensor_to_vector.
%
% Example (<a href="matlab:run_example tensor_to_vector">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

if isnumeric(T)
    t=T(:);
else
    t=zeros(prod(cellfun('size',T,1)),1);
    d=length(T);
    
    R=tensor_rank(T);
    for i=1:R
        u=1;
        for k=1:d
            u=revkron(u,T{k}(:,i));
        end
        t=t+u;
    end
end
