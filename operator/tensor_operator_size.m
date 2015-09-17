function d=tensor_operator_size( A, contract )

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

check_tensor_operator_format( A );

if nargin<2
    contract=false;
end

%d=[cellfun('size', A(1,:), 1 ); cellfun('size', A(1,:), 2 )]';
d=cellfun( @operator_size, A(1,:), 'UniformOutput', false );
d=cell2mat(d');

if contract
    d=prod(d,1);
end
