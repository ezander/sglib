function path=get_mfile_path
% GET_MFILE_PATH Return the complete path to the calling m-file.
%   GET_MFILE_PATH Returns the path to the calling m-file. I.e. if called
%   from '/home/userxyz/matlab/foo/bar.m' it will return
%   '/home/userxyz/matlab/foo'.
%
% Example: (<a href="matlab:run_example get_mfile_path">run</a>)
%     % when run with 'run_example' it should  return the path
%     % of the util directory
%     get_mfile_path
%
% See also MFILENAME, FILEPARTS, DBSTACK

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

s=dbstack('-completenames');
if length(s)<2
    path='';
else
    path=fileparts(s(2).file);
end
