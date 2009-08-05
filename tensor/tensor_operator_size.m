function S=tensor_operator_size( A, varargin )

%   Elmar Zander
%   Copyright 2009, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin{:} );
[optype,options]=get_option( options, 'optype', 'auto' );
check_unsupported_options( options, mfilename );

if strcmp( optype, 'auto' )
    if isnumeric(A)
        optype='revkron';
    elseif iscell(A)
        optype='tensor';
    else
        error( 'apply_tensor_operator:auto', 'cannot determine tensor operator type (%s)', class(A) );
    end
end


switch optype
    case 'revkron'
        S=size(A);
    case 'block'
        [M1,N1]=size(A);
        [M2,N2]=linear_operator_size(A{1,1});
        S=[M1*M2, N1*N2];
    case 'tensor'
        [M1,N1]=linear_operator_size(A{1,1});
        [M2,N2]=linear_operator_size(A{1,2});
        S=[M1*M2, N1*N2];
end
        
