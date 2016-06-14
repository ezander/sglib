function check_num_args(nargs, minargs, maxargs, mfilename, varargin)
% CHECK_NUM_ARGS Short description of check_num_args.
%   CHECK_NUM_ARGS(VARARGIN) Long description of check_num_args.
%
% Example (<a href="matlab:run_example check_num_args">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2016, Institute of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options( varargin, mfilename );
[mode,options]=get_option( options, 'mode', 'debug' );
[depth,options]=get_option( options, 'depth', 1 );
check_unsupported_options( options );

if nargs<minargs
    msg = 'Not enough input arguments';
elseif nargs>maxargs
    msg = 'Too many input arguments';
else
    return;
end

msg = strvarexpand('$msg$: given $nargs$ (min: $minargs$, max: $maxargs$)');
check_boolean(false, msg, mfilename, 'depth', depth+1, 'mode', mode);
