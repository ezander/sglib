function [r_i_alpha]=tensor_to_pce( R )
% TENSOR_TO_PCE Short description of tensor_to_pce.
%   TENSOR_TO_PCE Long description of tensor_to_pce.
%
% Example (<a href="matlab:run_example tensor_to_pce">run</a>)
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

%   Elmar Zander
%   Copyright 2007, Institute of Scientific Computing, TU Braunschweig.
%   $Id$
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% check input arguments
error( nargchk( 1, 1, nargin ) );

if ~iscell(R) || length(R)~=2
    error( 'sglib:tensor_to_pce', 'only tensors of order 2 supported' );
end

r_i_alpha=R{1}*R{2}';


