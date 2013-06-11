function log_start(basename,varargin)
% LOG_START Short description of log_start.
%   LOG_START Long description of log_start.
%
% Example (<a href="matlab:run_example log_start">run</a>)
%
% See also

%   Elmar Zander
%   Copyright 2011, Inst. of Scientific Computing, TU Braunschweig
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.

options=varargin2options(varargin);
[inctime,options]=get_option(options,'inctime',true);
[incsecs,options]=get_option(options,'incsecs',true);
[verbosity,options]=get_option(options,'verbosity',1);
check_unsupported_options(options,mfilename);

num=0;
s=datestring('separator','_','inctime', inctime,'incsecs', incsecs);
filename=[basename, '-', s, '.log'];
while exist( filename, 'file' )
    num=num+1;
    filename=[basename, '-', s, sprintf('-%03d.log',num)];
end
makesavepath( filename );
if verbosity>0
    fprintf( 'Logging to file: %s\n', filename );
end
diary( filename );
