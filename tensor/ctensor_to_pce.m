function [r_i_alpha]=ctensor_to_pce( R )
% CTENSOR_TO_PCE Short description of ctensor_to_pce.
%   CTENSOR_TO_PCE Long description of ctensor_to_pce.
%
% Example (<a href="matlab:run_example ctensor_to_pce">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2010, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

% check input arguments
check_num_args(nargin, 1, 1, mfilename);

if ~iscell(R) || length(R)~=2
    error( 'sglib:ctensor_to_pce', 'only tensors of order 2 supported' );
end

r_i_alpha=R{1}*R{2}';


