function startup
% STARTUP Set parameters/paths for the programs to run correctly.
%   Currently only adds paths to the normal search path. Maybe later
%   we could also look for an optional user options file and read that in.
%
% Note: In matlab this file should be executed automatically (at least,
%   when matlab was started in this directory). Otherwise, in octave for
%   instance, this file has to be executed manually (or should be invoked
%   from .octaverc)
%
% Example
%   startup
%
% See also 

%   Elmar Zander
%   Copyright 2006, Institute of Scientific Computing, TU Braunschweig.
%   $Id$ 
%
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version. 
%   See the GNU General Public License for more details. You should have
%   received a copy of the GNU General Public License along with this
%   program.  If not, see <http://www.gnu.org/licenses/>.


% persistent run_first
% if ~isempty(run_first)
%     return
% end
% run_first=false;

add_sglib_path( false, true )
